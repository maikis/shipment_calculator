module ShipmentCalculator
  class Result
    attr_reader :transactions
    attr_accessor :formatter

    # I thought this kind of design in the future will allow easy and
    # dynamically add different formatters and output classes, like for printing
    # to file, formatting to XML, etc.
    def initialize(transactions, formatter)
      @transactions = transactions
      @formatter = formatter
    end

    def output_result
      formatter.output_result(self)
    end
  end
end
