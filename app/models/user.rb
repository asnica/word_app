class User < ApplicationRecord
    has_many :words, dependent: :destroy
    has_many :tags, dependent: :destroy
    has_secure_password
    accepts_nested_attributes_for :tags, allow_destroy: true, reject_if: :all_blank

    # バリデーションの設定
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
end
