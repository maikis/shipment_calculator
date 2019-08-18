module ShipmentCalculator
  class Transaction
    attr_reader :date, :size, :short_name
    attr_accessor :shipment_price, :discount

    def initialize(date, size, short_name)
      @date = date
      @size = size
      @short_name = short_name
    end

    def valid?
      date.class == Date && providers_with_size_and_short_name_present?
    end

    private

    def providers
      @providers ||= ShipmentCalculator.providers
    end

    def providers_by_short_name
      providers.select { |provider| provider.short_name == short_name }
    end

    def providers_with_size_and_short_name_present?
      providers_by_short_name.select do |provider|
        provider.includes_size?(size)
      end.any?
    end
  end
end
