class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  enum :status, { active: 0, inactive: 1 }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
end
