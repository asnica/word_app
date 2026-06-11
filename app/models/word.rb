class Word < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :word_tags, dependent: :destroy
  has_many :tags, through: :word_tags
  include Hashid::Rails

  attr_accessor :remove_image
  before_save :purge_image, if: -> { remove_image == '1' }

  # バリデーションの設定
  validates :name, presence: true
  validates :meaning, presence: true
  validates :image, content_type: [:png, :jpg, :jpeg, :gif],
                    size: { less_than: 5.megabytes }

  def self.search(params)
    words = all.includes(:tags)

    if params[:query].present?
      q = "%#{params[:query]}%"
      case params[:search_scope]
      when 'name'
        words = words.where('words.name LIKE ?', q)
      when 'meaning'
        words = words.where('words.meaning LIKE ?', q)
      when 'synonym'
        words = words.where('words.synonym LIKE ?', q)
      else
        words = words.where('words.name LIKE :q OR words.meaning LIKE :q OR words.synonym LIKE :q', q: q)
      end
    end

    if params[:tag_ids].present?
      clean_tag_ids = params[:tag_ids].reject(&:blank?)
      if clean_tag_ids.any?
        words = words.joins(:tags).where(tags: { id: clean_tag_ids })
      end
    end

    words.distinct.order(created_at: :desc)
  end

  def self.to_csv
    require 'csv'
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << ['単語', '意味', '類義語', 'タグ', 'メモ']
      includes(:tags).each do |word|
        safe_name = word.name.to_s.start_with?("=") ? "'#{word.name}" : word.name
        safe_meaning = word.meaning.to_s.start_with?("=") ? "'#{word.meaning}" : word.meaning
        clean_synonym = word.synonym.to_s.split(',').map(&:strip).reject(&:blank?).join(', ')
        safe_synonym = clean_synonym.start_with?("=") ? "'#{clean_synonym}" : clean_synonym
        tag_names = word.tags.pluck(:name).join(', ')
        safe_tags = tag_names.start_with?("=") ? "'#{tag_names}" : tag_names
        safe_note = word.note.to_s.start_with?("=") ? "'#{word.note}" : word.note
        csv << [
          safe_name,
          safe_meaning,
          safe_synonym,
          safe_tags,
          safe_note
        ]
      end
    end
  end

  private

  def purge_image
    image.purge
  end
end
