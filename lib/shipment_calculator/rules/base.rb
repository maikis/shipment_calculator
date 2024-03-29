# frozen_string_literal: true

module ShipmentCalculator
  module Rules
    class Base
      def apply
        raise NotImplementedError
      end

      protected

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
