FactoryBot.define do
  factory :result, class: ShipmentCalculator::Result do

    initialize_with { new(transactions, formatter) }
  end
end
