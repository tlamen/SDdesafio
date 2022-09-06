# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :description
      t.integer :duration
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :week_day
      t.time :start_time

      t.timestamps
    end
  end
end
