module ShipmentCalculator
  module Rules
    class SmallShipmentLowestPriceRule < Base
      attr_reader :transactions

      SMALL = 'S'.freeze

      def initialize(transactions)
        @transactions = transactions
      end

      def apply
        transactions.map do |transaction|
          next unless transaction.size == SMALL

          transaction.shipment_price = lowest_price_for(transaction)
          transaction.discount = discount_for(transaction)
          transaction
        end
      end

      private

      def discount_for(transaction)
        regular_price(transaction) - lowest_price
      end

      def lowest_price_for(transaction)
        return lowest_price if regular_price(transaction) > lowest_price

        regular_price(transaction)
      end

      def regular_price(transaction)
        provider_by_short_name(transaction.short_name).price_by_size(SMALL)
      end

      def lowest_price
        @lowest_price ||= lowest_price_provider.price_by_size(SMALL)
      end

      def lowest_price_provider
        small_shipment_providers.min do |p1, p2|
          p1.price_by_size(SMALL) <=> p2.price_by_size(SMALL)
        end
      end

      def small_shipment_providers
        providers.select { |provider| provider.includes_size?(SMALL) }
      end

      def provider_by_short_name(short_name)
        # I'm choosing last provider assuming it's the most recent
        providers.select do |provider|
          provider.short_name == short_name
        end.last
      end
    end
  end
end
