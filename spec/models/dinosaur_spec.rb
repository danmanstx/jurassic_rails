# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dinosaur, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should belong_to(:cage) }
    it { should belong_to(:species) }
  end

  describe 'scopes' do
    let!(:cage1) { create(:cage, power_status: :active) }
    let!(:species) { create(:species, name: 'Trex', diet: :carnivore) }
    let!(:dinosaur) { create(:dinosaur, cage: cage1, species:) }

    it 'by_species' do
      expect(Dinosaur.by_species(dinosaur.species.name)).to eq([dinosaur])
    end

    it 'with_species' do
      expect(Dinosaur.with_species).to eq([dinosaur])
    end
  end
end
