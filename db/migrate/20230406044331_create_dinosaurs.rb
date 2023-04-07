# frozen_string_literal: true

# db/migrate/20230406044331_create_dinosaurs.rb
class CreateDinosaurs < ActiveRecord::Migration[6.1]
  def change
    create_table :dinosaurs do |t|
      t.string :name
      t.references :cage, null: false, foreign_key: true
      t.references :species, null: false, foreign_key: true

      t.timestamps
    end
  end
end
