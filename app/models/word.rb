class Word < ApplicationRecord
  belongs_to :user
  has_many :word_tags, dependent: :destroy
  has_many :tags, through: :word_tags

  # バリデーションの設定
  validates :name, presence: true
  validates :meaning, presence: true
end
