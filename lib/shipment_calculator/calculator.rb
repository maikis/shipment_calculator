module ShipmentCalculator
  class Calculator
    attr_reader :shipment_data, :rules

    def initialize(shipment_data, rules)
      @shipment_data = shipment_data
      @rules = rules
    end
  end
end
