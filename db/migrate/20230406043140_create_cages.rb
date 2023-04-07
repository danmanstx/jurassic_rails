# frozen_string_literal: true

# db/migrate/20230406043140_create_cages.rb
class CreateCages < ActiveRecord::Migration[6.1]
  def change
    create_table :cages do |t|
      t.string :name
      t.integer :capacity
      t.integer :power_status, default: 0

      t.timestamps
    end
  end
end
