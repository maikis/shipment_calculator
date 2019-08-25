module ShipmentCalculator
  class Calculator
    attr_reader :valid_transactions, :rules

    def initialize(transactions, rules)
      @valid_transactions = transactions.select(&:valid?)
      @rules = rules
    end

    def basic_calculate
      rules.each do |rule|
        rule.new(valid_transactions).apply
      end
    end
  end
end
