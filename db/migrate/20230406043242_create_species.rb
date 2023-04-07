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
