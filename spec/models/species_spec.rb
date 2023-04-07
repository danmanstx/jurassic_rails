# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Species, type: :model do
  subject(:species) { described_class.new(name: 'Tyrannosaurus', diet: 'carnivore') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:diet) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:dinosaurs) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:diet).with_values(unknown: 0, carnivore: 1, herbivore: 2) }
  end

  describe '#name' do
    it 'returns the name of the species' do
      expect(species.name).to eq('Tyrannosaurus')
    end
  end

  describe '#diet' do
    it 'returns the diet of the species' do
      expect(species.diet).to eq('carnivore')
    end
  end
end
