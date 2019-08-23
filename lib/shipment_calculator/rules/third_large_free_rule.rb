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
              transaction.shipment_price = price(transaction, pos)
              transaction.discount = discount(transaction, pos)
            end
            transaction
          end
        end.flatten
      end

      private

      def discount(transaction, pos)
        third?(pos) ? providers_price(transaction) : 0
      end

      def price(transaction, pos)
        third?(pos) ? 0 : providers_price(transaction)
      end

      def third?(pos)
        pos == 2
      end

      def providers_price(transaction)
        provider(transaction).price_by_size(SIZE)
      end

      def provider(transaction)
        providers.detect do |provider|
          provider.short_name == transaction.short_name
        end
      end

      def months
        transactions.map do |transaction|
          [transaction.date.year, transaction.date.month]
        end.uniq
      end

      def transactions_at(year, month)
        transactions.select do |transaction|
          transaction.date.year == year && transaction.date.month == month
        end
      end
    end
  end
end
