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
    words = all.includes(:tags).left_outer_joins(:tags).distinct
    if params[:query].present?
      q = "%#{params[:query]}%"
      words = words.where(
        "words.name LIKE ? OR words.meaning LIKE ? OR tags.name LIKE ?", 
        q, q, q
        )
    end

    if params[:tag_ids].present?
      words = words.where(tags: { id: params[:tag_ids] })
    end

    words
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
