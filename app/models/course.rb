class Course < ApplicationRecord
  belongs_to :category_id
  belongs_to :teacher_id
end
