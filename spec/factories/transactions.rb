FactoryBot.define do
  factory :transaction, class: ShipmentCalculator::Transaction do
    date { Date.parse('2015-02-01') }
    size { 'XL' }
    short_name { 'MRLP' }

    trait :small do
      size { 'S' }
    end

    trait :medium do
      size { 'M' }
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

    trait :no_discount do
      shipment_price { 2 }
      discount { 0 }
    end

    trait :not_valid do
      date { '2015-02-01' }
      size { 'CUSPS' }
      short_name { nil }
    end

    initialize_with { new(date, size, short_name) }
  end
end
