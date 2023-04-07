# frozen_string_literal: true

# app/models/dinosaur.rb
class Dinosaur < ApplicationRecord
  belongs_to :cage, counter_cache: true
  belongs_to :species

  validates_presence_of :name
  validates_presence_of :species
  validates_associated :cage, message: ->(_class_obj, obj) { obj[:value].errors.full_messages.join(',') }
  after_commit :remove_misplaced_herbivore, on: %i[create update]

  scope :by_species, ->(name) { joins(:species).where(species: { name: }) if name.present? }
  scope :by_diet, ->(diet) { joins(:species).where(species: { diet: }) if diet.present? }
  scope :with_species, -> { includes(:species) }
  scope :expanded, -> { with_species.to_json(include: :species) }

  def remove_misplaced_herbivore
    carnivores = cage.dinosaurs.by_diet(:carnivore)
    herbivore = cage.dinosaurs.by_diet(:herbivore)
    return unless carnivores.present? && herbivore.present?

    destroy
    errors.add(:dinosaur, 'Herbivores can only be in a cage with other herbivores.')
  end
end
