# frozen_string_literal: true

module ShipmentCalculator
  module Rules
    class BudgetRule < Base
      attr_reader :transactions, :monthly_budget, :current_budget

      # By allowing to set monthly budget amount on initialization, code becomes
      # much more flexible.
      def initialize(transactions, monthly_budget = 10)
        @transactions = transactions
        @monthly_budget = monthly_budget
        @current_budget = monthly_budget
      end

      def apply
        months.each do |year, month|
          @current_budget = monthly_budget
          transactions_at(year, month).each do |transaction|
            adjust_discount(transaction)
          end
        end
      end

      private

      def adjust_discount(transaction)
        return transaction if transaction.discount.zero?

        if current_budget.zero?
          transaction.shipment_price += transaction.discount
          transaction.discount = 0
        elsif current_budget.positive? && current_budget < transaction.discount
          transaction.shipment_price += (transaction.discount - current_budget)
          transaction.discount = current_budget
          @current_budget -= current_budget
        else
          @current_budget -= transaction.discount
        end
        transaction
      end
    end
  end
end
