FactoryBot.define do
  factory :provider, class: ShipmentCalculator::Provider do
    short_name { 'RANDOM' }
    sizes_with_prices { { 'L' => 6.9 } }

    trait :lp do
      short_name { 'LP' }
    end

    trait :mr do
      short_name { 'MR' }
    end

    initialize_with { new(short_name, sizes_with_prices) }
  end
end
