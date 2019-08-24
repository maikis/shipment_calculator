require 'yaml'
require 'date'

require 'version'
require 'calculator'
require 'provider'
require 'transaction'
require 'result'
require 'stdout_formatter'

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
    tr_data = transaction_data(file_name)
    tr_data_valid = tr_data.select(&:valid?)
    [Rules::SmallShipmentLowestPriceRule, Rules::ThirdLargeFreeRule, Rules::BudgetRule].each do |rule|
      rule.new(tr_data_valid).apply
    end
    Result.new(tr_data, StdoutFormatter.new).output_result
  end

  def self.transaction_data(file_name)
    # file_name defaults to 'input.txt' as stated in homework assignment.
    file_name = file_name.nil? ? 'input.txt' : file_name
    File.new("data/#{file_name}", 'r').map do |line|
      data = line.chomp.split(' ')
      data[DATE] = Date.parse(data[DATE]) rescue data[DATE]
      transaction = ShipmentCalculator::Transaction.new(data[DATE], data[SIZE], data[PRICE])
      provider = providers.detect { |provider| provider.short_name == transaction.short_name }
      if transaction.valid?
        transaction.shipment_price = provider.price_by_size(transaction.size)
        transaction.discount = 0
      end
      transaction
    end
  end

  # Defining providers in yaml gives more flexibility to add or remove
  # providers and their data.
  def self.providers
    @providers ||= begin
      provider_config = Psych.load_file('config/providers.yml')
      provider_config.map do |short_name, sizes_with_prices|
        Provider.new(short_name, sizes_with_prices)
      end
    end
  end
end
