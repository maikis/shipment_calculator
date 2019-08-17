module ShipmentCalculator
  class Transaction
    attr_reader :date, :size, :provider

    def initialize(date, size, provider)
      @date = date
      @size = size
      @provider = provider
    end
  end
end
