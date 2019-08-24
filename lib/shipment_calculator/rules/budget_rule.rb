module ShipmentCalculator
  module Rules
    class BudgetRule < Base
      attr_reader :transactions, :monthly_budget, :current_month_budget

      # By allowing to set monthly budget amount on initialization, code becomes
      # much more flexible.
      def initialize(transactions, monthly_budget = 10)
        @transactions = transactions
        @monthly_budget = monthly_budget
        @current_month_budget = monthly_budget
      end

      def apply
        months.map do |year, month|
          @current_month_budget = monthly_budget
          transactions_at(year, month).map do |transaction|
            adjust_discount(transaction)
          end
        end.flatten
      end

      private

      def adjust_discount(transaction)
        if transaction.shipment_price.nil? || transaction.discount.nil?
          return transaction
        end

        if current_month_budget.zero?
          transaction.shipment_price += transaction.discount
          transaction.discount = 0
        elsif current_month_budget.positive? && current_month_budget < transaction.discount
          transaction.shipment_price += (transaction.discount - current_month_budget)
          transaction.discount = current_month_budget
          @current_month_budget -= current_month_budget
        else
          @current_month_budget -= transaction.discount
        end
        transaction
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
