# app/models/dinosaur.rb
class Dinosaur < ApplicationRecord
  belongs_to :cage
  belongs_to :species

  validates_associated :cage
  validates :name, presence: true

  scope :by_species, ->(name) { joins(:species).where(species: { name: }) if name.present? }
  scope :by_diet, ->(diet) { joins(:species).where(species: { diet: }) if diet.present? }
  scope :with_species, -> { includes(:species) }
  scope :expanded, -> { with_species.to_json(include: :species) }

end
