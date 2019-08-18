module ShipmentCalculator
  class Calculator
    attr_reader :transaction_data, :rules

    def initialize(transaction_data, rules)
      @transaction_data = transaction_data
      @rules = rules
    end
  end
end
