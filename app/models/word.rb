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

  private

  def purge_image
    image.purge
  end
end
