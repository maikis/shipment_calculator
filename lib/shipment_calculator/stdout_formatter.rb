module ShipmentCalculator
  class StdoutFormatter
    def output_result(context)
      context.transactions.each do |transaction|
        if transaction.valid?
          puts "#{transaction.date} #{transaction.size} "\
            "#{transaction.short_name} #{currency_format(transaction.shipment_price)} "\
            "#{discount_format(transaction.discount)}"
        else
          transaction_details = "#{transaction.date} #{transaction.size} "\
            "#{transaction.short_name}".chomp
          puts transaction_details + 'Ignored'
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
  end
end
