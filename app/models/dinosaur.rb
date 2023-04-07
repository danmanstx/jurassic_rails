# frozen_string_literal: true

# app/models/dinosaur.rb
class Dinosaur < ApplicationRecord
  belongs_to :cage, counter_cache: true
  belongs_to :species

  validates_presence_of :name
  validates_presence_of :species
  validates_associated :cage, message: ->(_class_obj, obj) { obj[:value].errors.full_messages.join(',') }

  scope :by_species, ->(name) { joins(:species).where(species: { name: }) if name.present? }
  scope :by_diet, ->(diet) { joins(:species).where(species: { diet: }) if diet.present? }
  scope :with_species, -> { includes(:species) }
  scope :expanded, -> { with_species.to_json(include: :species) }
end
