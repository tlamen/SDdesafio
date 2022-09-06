# frozen_string_literal: true

class ChangeTeacherFieldCourse < ActiveRecord::Migration[6.1]
  def change
    rename_column :courses, :teacher_id, :user_id
  end
end
