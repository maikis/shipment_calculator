module ShipmentCalculator
  module Rules
    class ThirdLargeFreeRule < Base
      attr_reader :transactions

      PROVIDER = 'LP'.freeze
      SIZE = 'L'.freeze

      def initialize(transactions)
        @transactions = transactions.select do |tr|
          tr.size == SIZE && tr.short_name == PROVIDER
        end
      end

      def apply
        months.map do |year, month|
          transactions_at(year, month).map.with_index do |transaction, pos|
            if transaction.size == SIZE
              transaction.shipment_price = price(transaction.provider, pos)
              transaction.discount = discount(transaction.provider, pos)
            end
            transaction
          end
        end.flatten
      end

      private

      def discount(provider, pos)
        third?(pos) ? provider.price_for(size: SIZE) : 0
      end

      def price(provider, pos)
        third?(pos) ? 0 : provider.price_for(size: SIZE)
      end

      def third?(pos)
        pos == 2
      end
    end
  end
end
