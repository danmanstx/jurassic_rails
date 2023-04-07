# frozen_string_literal: true

# db/migrate/20230406043242_create_species.rb
class CreateSpecies < ActiveRecord::Migration[6.1]
  def change
    create_table :species do |t|
      t.string :name
      t.integer :diet, default: 0

      t.timestamps
    end
    add_index :species, :name, unique: true
  end
end
