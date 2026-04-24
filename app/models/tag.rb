class Tag < ApplicationRecord
  belongs_to :user
  has_many :words, dependent: :nullify
  
  validates :name, presence: true
end