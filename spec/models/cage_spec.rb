# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cage, type: :model do
  describe 'associations' do
    it { should have_many(:dinosaurs) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:capacity).is_greater_than(0) }

    it 'validates that the cage is not over capacity' do
      cage = create(:cage, capacity: 1)
      species = create(:species, name: 'Trex', diet: :carnivore)
      dinosaur = create(:dinosaur, cage:, species:)
      dinosaur2 = create(:dinosaur, cage:, species:)
      cage.reload
      expect(cage).to_not be_valid
    end

    it 'validates that the cage is not powered off with dinosaurs inside' do
      cage = create(:cage, capacity: 5, power_status: :active)
      species = create(:species, name: 'Trex', diet: :carnivore)
      dinosaur = create(:dinosaur, cage:, species:)
      cage.update(power_status: :down)
      cage.reload
      expect(cage).to_not be_valid
    end
  end

  describe 'scopes' do
    let!(:cage1) { create(:cage, power_status: :active) }
    let!(:cage2) { create(:cage, power_status: :down) }
    let!(:species) { create(:species, name: 'Trex', diet: :carnivore) }
    let!(:dinosaur1) { create(:dinosaur, cage: cage1, species:) }
    let!(:dinosaur2) { create(:dinosaur, cage: cage2, species:) }

    describe '.by_status' do
      it 'returns cages with a matching power status' do
        expect(Cage.by_status(:active).count).to eq(1)
        expect(Cage.by_status(:down).count).to eq(1)
      end
    end

    describe '.with_dinos' do
      it 'includes dinosaurs in the cages' do
        expect(Cage.with_dinos.first).to eq(cage1)
        expect(Cage.with_dinos.second).to eq(cage2)
      end
    end
  end

  describe 'methods' do
    let!(:cage) { create(:cage, capacity: 5) }
    let!(:species) { create(:species, name: 'Trex', diet: :carnivore) }
    let!(:dinosaur) { create(:dinosaur, cage:, species:) }

    describe '#current_capacity' do
      it 'returns the number of dinosaurs currently in the cage' do
        cage.reload
        expect(cage.current_capacity).to eq(1)
      end
    end

    describe '#power_on' do
      it 'returns true and updates the power status of the cage to true if the cage is powered off' do
        cage.update(power_status: :down)
        expect(cage.power_on).to eq(true)
        expect(cage.power_status).to eq('active')
      end
    end

    describe '#power_off' do
      it 'returns true and updates the power status of the cage to false if the cage is powered on and empty' do
        cage1 = create(:cage, capacity: 1, power_status: :active)
        expect(cage1.power_off).to eq(true)
        expect(cage1.power_status).to eq('down')
      end

      it 'returns false and adds an error if the cage is powered on and not empty' do
        cage.reload
        expect(cage.power_off).to eq(false)
        expect(cage.errors.full_messages).to eq(['Cage is not empty and cannot be powered off'])
      end
    end
  end
end
