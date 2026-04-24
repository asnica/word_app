class Word < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  # バリデーションの設定
  validates :name, presence: true
  validates :meaning, presence: true
end
