class Word < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :word_tags, dependent: :destroy
  has_many :tags, through: :word_tags

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

    words.distinct
  end

  def self.to_csv
    require 'csv'
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << ['ID', '単語', '意味', '類義語', 'タグ', 'メモ']
      all.includes(:tags).find_each do |word|
        clean_synonym = word.synonym.to_s.split(',').map(&:strip).reject(&:blank?).join(', ')
        csv << [
          word.id,
          word.name,
          word.meaning,
          clean_synonym,
          word.tags.pluck(:name).join(', '),
          word.note
        ]
      end
    end
  end

  private

  def purge_image
    image.purge
  end
end
