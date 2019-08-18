module ShipmentCalculator
  module Rules
    class Base
      def apply
        raise NotImplementedError
      end

      # Defining providers in yaml gives more flexibility to add or remove
      # providers and their data.
      def providers
        @providers ||= begin
          provider_config = Psych.load_file('config/providers.yml')
          provider_config.map do |short_name, sizes_with_prices|
            Provider.new(short_name, sizes_with_prices)
          end
        end
      end
    end
  end
end
