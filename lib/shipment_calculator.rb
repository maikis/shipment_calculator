require 'yaml'
require 'date'

require 'version'
require 'calculator'
require 'provider'
require 'transaction'

Dir[File.join(__dir__, 'shipment_calculator', 'rules', '*.rb')].each do |file|
  require file
end

module ShipmentCalculator
  class Error < StandardError; end

  DATE = 0
  SIZE = 1
  PRICE = 2

  # Main calculation "initializer". Accepts file name of input data file as a
  # parameter.
  def self.calculate(file_name)
  end

  def self.transaction_data(file_name)
    # file_name defaults to 'input.txt' as stated in homework assignment.
    file_name = file_name.nil? ? 'input.txt' : file_name
    File.new("data/#{file_name}", 'r').map do |line|
      data = line.chomp.split(' ')
      data[DATE] = Date.parse(data[DATE]) rescue nil
      ShipmentCalculator::Transaction.new(data[DATE], data[SIZE], data[PRICE])
    end
  end
end
