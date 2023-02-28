# frozen_string_literal: true

class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees, id: :uuid do |t|
      t.integer :emp_id, null: false
      t.string :email, null: false
      t.string :full_name, null: false

      # Some extra information, to return in the response.
      t.string :address, null: true, default: nil
      t.string :phone_number, null: true, default: nil

      t.timestamps
    end

    add_index :employees, :emp_id, unique: true
    add_index :employees, :email, unique: true
    add_index :employees, :created_at, unique: true
  end
end
