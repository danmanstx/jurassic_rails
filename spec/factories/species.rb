# frozen_string_literal: true

FactoryBot.define do
  factory :species do
    name { 'TRex' }
    diet { :carnivore }
  end
end
