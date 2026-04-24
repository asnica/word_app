class Tag < ApplicationRecord
  belongs_to :user
  has_many :word_tags, dependent: :destroy
  has_many :words, dependent: :nullify
  
  validates :name, presence: true
end