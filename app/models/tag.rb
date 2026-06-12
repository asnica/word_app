class Tag < ApplicationRecord
  belongs_to :user
  has_many :word_tags, dependent: :destroy
  has_many :words, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def self.search(search_word)
    if search_word.present?
      where("name LIKE ?", "%#{search_word}%")
    else
      all
    end
  end
end
