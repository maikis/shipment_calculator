FactoryBot.define do
  factory :transaction, class: ShipmentCalculator::Transaction do
    date { Date.parse('2019-02-01') }
    size { 'L' }
    short_name { 'LP' }

    trait :small do
      size { 'L' }
    end

    trait :medium do
      size { 'L' }
    end

    trait :large do
      size { 'L' }
    end

    trait :lp do
      short_name { 'LP' }
    end

    trait :mr do
      short_name { 'MR' }
    end

    trait :with_discount do
      shipment_price { 2 }
      discount { 1 }
    end

    initialize_with { new(date, size, short_name) }
  end
end
