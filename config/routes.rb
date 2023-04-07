# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'api/v1/cages#index'
  namespace :api do
    namespace :v1 do
      resources :dinosaurs
      resources :species
      resources :cages do
        patch 'power_on', to: 'cages#power_on'
        patch 'power_off', to: 'cages#power_off'
        resources :dinosaurs, only: %i[index create]
      end
    end
  end
end
