# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CagesController, type: :request do
  let!(:cages) { create_list(:cage, 5) }
  let(:cage_id) { cages.first.id }
  let!(:species) { create(:species, name: 'Trex', diet: :carnivore) }
  let!(:dinosaur1) { create(:dinosaur, cage: cages.first, species:) }
  let!(:dinosaur2) { create(:dinosaur, cage: cages.first, species:) }

  describe 'GET /api/v1/cages' do
    context 'when power status is present' do
      before { get '/api/v1/cages', params: { power_status: 'active' } }

      it 'returns cages with specified power status' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when power status is not present' do
      before { get '/api/v1/cages' }

      it 'returns all cages' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when expanded parameter is present' do
      before { get '/api/v1/cages', params: { expanded: true } }

      it 'returns all cages with dinosaurs' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body).size).to eq(5)
        expect(JSON.parse(response.body).first['dinosaurs']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /api/v1/cages/:id' do
    before { get "/api/v1/cages/#{cage_id}" }

    context 'when the record exists' do
      it 'returns the cage' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(cage_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /cages' do
    context 'when the request is valid' do
      let(:valid_attributes) { { name: 'Cage 1', capacity: 10 } }

      before { post '/api/v1/cages', params: valid_attributes }

      it 'creates a cage' do
        expect(response.body).to include('Cage 1')
        expect(response.body).to include('10')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/cages', params: { name: 'Cage 1', capacity: -1 } }

      it 'returns a validation failure message' do
        expect(response.body).to include('must be greater than 0')
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
