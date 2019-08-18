module ShipmentCalculator
  class Result
    attr_reader :transaction, :shipment_price, :discount

    def initialize(transaction, shipment_price, discount)
      @transaction = transaction
      @shipment_price = shipment_price
      @discount = discount
    end
  end
end
