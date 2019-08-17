require 'yaml'
require 'date'

require 'version'
require 'calculator'
require 'provider'
require 'transaction'

module ShipmentCalculator
  class Error < StandardError; end

  # Main calculation "initializer". Accepts file name of input data file as a
  # parameter.
  def self.calculate(file_name)
  end

  # Defining providers in yaml gives more flexibility to add or remove providers
  # and their data.
  def self.providers
    provider_config = Psych.load_file('config/providers.yml')
    provider_config.map do |short_name, sizes_with_prices|
      Provider.new(short_name, sizes_with_prices)
    end
  end

  def self.shipment_data(file_name)
    # file_name defaults to 'input.txt' as stated in homework assignment.
    file_name = file_name.nil? ? 'input.txt' : file_name
    File.new("data/#{file_name}", 'r').map do |line|
      data = line.chomp.split(' ')
      data[0] = Date.parse(data[0]) rescue nil
      ShipmentCalculator::Transaction.new(data[0], data[1], data[2])
    end
  end
end
