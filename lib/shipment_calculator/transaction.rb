module ShipmentCalculator
  class Transaction
    attr_reader :date, :size, :short_name
    attr_accessor :shipment_price, :discount

    def initialize(date, size, short_name)
      @date = date
      @size = size
      @short_name = short_name
      return unless valid?

      @shipment_price = provider.price_by_size(size)
      @discount = 0
    end

    def valid?
      date.class == Date && provider_present?
    end

    def self.from_data(date:, size:, short_name:)
      begin
        date = Date.parse(date)
      rescue ArgumentError
        nil
      end
      transaction = ShipmentCalculator::Transaction.new(date, size, short_name)

      transaction
    end

    private

    def provider
      providers.detect do |provider|
        provider.short_name == short_name && provider.includes_size?(size)
      end
    end

    def providers
      @providers ||= ShipmentCalculator.providers
    end

    def provider_present?
      !provider.nil?
    end
  end
end
