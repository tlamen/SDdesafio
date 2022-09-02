class Category < ApplicationRecord
    has_many :courses, dependent: :destroy

    validates_presence_of :name, :description
    validates :name, uniqueness: true
end
