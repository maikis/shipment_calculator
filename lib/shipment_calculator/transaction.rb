# frozen_string_literal: true

module ShipmentCalculator
  class Transaction
    attr_reader :date, :size, :short_name
    attr_accessor :shipment_price, :discount

    def initialize(date, size, short_name)
      @date = date
      @size = size
      @short_name = short_name
      return unless valid?

      @shipment_price = regular_price
      @discount = 0
    end

    def valid?
      date.class == Date && provider_present?
    end

    def provider
      @provider ||= Provider.all.detect do |provider|
        provider.short_name == short_name && provider.includes_size?(size)
      end
    end

    def regular_price
      @regular_price ||= provider.price_for(size: size)
    end

    def self.from_data(date:, size:, short_name:)
      begin
        date = Date.parse(date)
      rescue ArgumentError
        nil
      end
      new(date, size, short_name)
    end

    private

    def provider_present?
      !provider.nil?
    end
  end
end
