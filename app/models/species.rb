# frozen_string_literal: true

# app/models/species.rb
class Species < ApplicationRecord
  enum diet: { unknown: 0, carnivore: 1, herbivore: 2 }
  has_many :dinosaurs

  validates :diet, presence: true
  validates :name, presence: true
end
