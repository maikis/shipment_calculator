FactoryBot.define do
  factory :provider, class: ShipmentCalculator::Provider do
    short_name { 'LP' }
    sizes_with_prices { { 'L' => 6.9 } }

    initialize_with { new(short_name, sizes_with_prices) }
  end
end
