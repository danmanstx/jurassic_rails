# frozen_string_literal: true

# app/models/cage.rb
class Cage < ApplicationRecord
  enum power_status: { down: 0, active: 1 }
  has_many :dinosaurs, dependent: :nullify

  validates :capacity, numericality: { greater_than: 0 }
  validate :occupancy
  validate :power_off_dino_check, on: %i[update create]
  validate :carnivore_species_only

  scope :by_status, ->(power_status) { where(power_status:) if power_status.present? }
  scope :with_dinos, -> { includes(:dinosaurs) }
  scope :expanded, -> { with_dinos.to_json(include: :dinosaurs) }

  def current_capacity
    dinosaurs.size
  end

  def power_on
    return true if power_status == 'active'

    true && update(power_status: :active)
  end

  def power_off
    return true if power_status == 'down'
    return true && update(power_status: :down) if current_capacity.zero? && dinosaurs.empty?

    errors.add(:cage, 'is not empty and cannot be powered off')
    false
  end

  def power_off_dino_check
    return unless power_status == 'down' && dinosaurs.present?

    errors.add(:cage, 'is not empty and cannot be powered off')
  end

  def occupancy
    errors.add(:cage, 'is at max capacity') if current_capacity >= capacity
  end

  def carnivore_species_only
    carnivores = dinosaurs.by_diet(:carnivore)
    return if carnivores.empty? || carnivores.map(&:species).uniq.length == 1

    errors.add(:dinosaurs, 'Carnivores can only be in a cage with other dinosaurs of the same species.')
  end
end
