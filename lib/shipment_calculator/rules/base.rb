module ShipmentCalculator
  module Rules
    class Base
      def apply
        raise NotImplementedError
      end

      def providers
        @providers ||= ShipmentCalculator.providers
      end
    end
  end
end
