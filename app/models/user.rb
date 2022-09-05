class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name, :email, :birthdate, :role
  validates_date :birthdate, before: -> { Date.current }
  has_many :courses, dependent: :destroy
  validates :role, acceptance: { accept: [1, 2, 3] }
end
