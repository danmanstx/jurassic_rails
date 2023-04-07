# frozen_string_literal: true

FactoryBot.define do
  factory :dinosaur do
    name { 'Bob' }
    cage_id { 1 }
    species_id { 2 }
  end
end
