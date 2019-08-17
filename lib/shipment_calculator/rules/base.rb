module ShipmentCalculator
  module Rules
    class Base
      def apply(_transaction_data)
        raise NotImplementedError
      end
    end
  end
end
