# frozen_string_literal: true

module ShipmentCalculator
  # Formatter class which prints to STDOUT. If module would have a need to
  # evolve, this file could be moved to separate formatter folder and other
  # formatters, like XML, file output, etc. might be added. But for now I
  # decided to leave it in the main folder as we have no other formatter.
  class StdoutFormatter
    def output_result(context)
      context.transactions.each do |transaction|
        if transaction.valid?
          puts all_values(transaction).join(' ')
        else
          puts transaction_details(transaction).join(' ') + 'Ignored'
        end
      end
    end

    private

    def currency_format(amount)
      format('%.2f', amount).to_s
    end

    def discount_format(amount)
      amount.positive? ? currency_format(amount) : '-'
    end

    def all_values(transaction)
      transaction_details(transaction) + pricing_details(transaction)
    end

    def transaction_details(transaction)
      [transaction.date,
       transaction.size,
       transaction.short_name]
    end

    def pricing_details(transaction)
      [currency_format(transaction.shipment_price),
       discount_format(transaction.discount)]
    end
  end
end
