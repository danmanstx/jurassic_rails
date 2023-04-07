FactoryBot.define do
  factory :cage do
    name { "Name" }
    capacity { 5 }
    power_status { :active }
  end
end
