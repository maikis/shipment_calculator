module ShipmentCalculator
  class Result
    attr_reader :transaction
    attr_accessor :shipment_price, :discount

    def initialize(transaction, shipment_price = nil, discount = nil)
      @transaction = transaction
      @shipment_price = shipment_price
      @discount = discount
    end
  end
end
