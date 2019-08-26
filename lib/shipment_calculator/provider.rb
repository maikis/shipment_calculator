module ShipmentCalculator
  class Provider
    attr_reader :short_name, :sizes_with_prices

    # Accepts attributes:
    #
    # short_name: String
    # sizes_with_prices: { 'size1' => price1, 'size2' => price2 } - String keys.
    #
    # Real system might have validations to ensure sizes_with_prices is a hash.
    def initialize(short_name, sizes_with_prices)
      @short_name = short_name
      @sizes_with_prices = sizes_with_prices || {}
    end

    def price_for(size:)
      sizes_with_prices.fetch(size)
    end

    def includes_size?(size)
      sizes_with_prices.keys.include?(size)
    end

    def self.all
      ShipmentCalculator.providers
    end
  end
end
