# frozen_string_literal: true

class ChangeRegistrationToActivity < ActiveRecord::Migration[6.1]
  def change
    remove_reference :registrations, :course
    add_reference :registrations, :activity, foreign_key: true
  end
end
