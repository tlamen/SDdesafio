class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :courses, :user_id, :teacher_id
  end
end
