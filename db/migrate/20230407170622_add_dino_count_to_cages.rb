# frozen_string_literal: true

# db/migrate/20230407170622_add_dino_count_to_cages.rb
class AddDinoCountToCages < ActiveRecord::Migration[6.1]
  def change
    add_column :cages, :dinosaurs_count, :integer
  end
end
