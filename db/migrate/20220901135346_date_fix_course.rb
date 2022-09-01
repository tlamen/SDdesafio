class DateFixCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :week_day, :string
    add_column :courses, :start_time, :time
    remove_column :courses, :start
  end
end
