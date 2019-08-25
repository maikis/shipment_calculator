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
  SHORT_NAME = 2

  MAIN_STRATEGY = [
    Rules::SmallShipmentLowestPriceRule,
    Rules::ThirdLargeFreeRule,
    Rules::BudgetRule
  ].freeze

  # Main calculation "initializer". Accepts file name of input data file as a
  # parameter. The idea was that for now simple calculate method will be enough,
  # though if module will have a need to grow in the future, then it would be
  # easy to simply add other method, like custom_calculate etc. Or we could
  # go even more magic way and accept calculation strategy as a parameter and
  # form custom calculator instance to do the job.
  def self.calculate(file_name)
    transactions = transaction_data(file_name)
    valid_transactions = transactions.select(&:valid?)
    MAIN_STRATEGY.each do |rule|
      rule.new(valid_transactions).apply
    end
    Result.new(transactions, StdoutFormatter.new).output_result
  end

  def self.transaction_data(file_name)
    file_name = file_name.nil? ? 'input.txt' : file_name
    File.new("data/#{file_name}", 'r').map do |line|
      data = line.chomp.split(' ')
      Transaction.from_data(
        date: data[DATE],
        size: data[SIZE],
        short_name: data[SHORT_NAME]
      )
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
