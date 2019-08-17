require 'yaml'
require 'version'
require 'provider'

module ShipmentCalculator
  class Error < StandardError; end

  # Main calculation "initializer". Accepts file name of input data file as a
  # parameter, defaults to 'input.txt' as stated in homework assignment.
  def self.calculate(file_name = 'input.txt')
    data_file = File.new("lib/shipment_calculator/data/#{file_name}", 'r')
  end

  def self.providers
    provider_config = Psych.load_file('config/providers.yml')
    provider_config.map do |short_name, sizes_with_prices|
      Provider.new(short_name, sizes_with_prices)
    end
  end
end
