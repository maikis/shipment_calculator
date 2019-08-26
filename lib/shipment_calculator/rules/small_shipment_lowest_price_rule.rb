# frozen_string_literal: true

module ShipmentCalculator
  module Rules
    class SmallShipmentLowestPriceRule < Base
      attr_reader :transactions

      SMALL = 'S'.freeze

      def initialize(transactions)
        @transactions = transactions.select do |transaction|
          transaction.size == SMALL
        end
      end

      def apply
        transactions.each do |transaction|
          transaction.shipment_price = lowest_price_for(transaction)
          transaction.discount = discount_for(transaction)
          transaction
        end
      end

      private

      def discount_for(transaction)
        transaction.regular_price - lowest_price
      end

      def lowest_price_for(transaction)
        return lowest_price if transaction.regular_price > lowest_price

        transaction.regular_price
      end

      def regular_price(transaction)
        transaction.provider.price_for(size: SMALL)
      end

      def lowest_price
        @lowest_price ||= lowest_price_provider.price_for(size: SMALL)
      end

      def lowest_price_provider
        small_shipment_providers.min do |p1, p2|
          p1.price_for(size: SMALL) <=> p2.price_for(size: SMALL)
        end
      end

      def small_shipment_providers
        Provider.all.select { |provider| provider.includes_size?(SMALL) }
      end
    end
  end
end
