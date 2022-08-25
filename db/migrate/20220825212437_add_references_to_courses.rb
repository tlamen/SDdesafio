class AddReferencesToCourses < ActiveRecord::Migration[6.1]
  def change
    add_reference :courses, :category, foreign_key: true
    add_reference :courses, :user, foreign_key: true
  end
end
