module ShipmentCalculator
  module Rules
    class Base
      def shipment_price
        raise NotImplementedError
      end

      def discount
        raise NotImplementedError
      end

      def providers
        @providers ||= ShipmentCalculator.providers
      end
    end
  end
end
