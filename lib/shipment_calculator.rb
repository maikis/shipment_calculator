# frozen_string_literal: true

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

  # For current solution this kind of list is sufficient, but if different
  # types of calculations would be needed, then it would make sense to
  # put strategies to separate classes and use strategy pattern, or something
  # like that.
  MAIN_STRATEGY = [
    Rules::SmallShipmentLowestPriceRule,
    Rules::ThirdLargeFreeRule,
    Rules::BudgetRule
  ].freeze

  # Main calculation "initializer" method. Accepts file name of input data file
  # as a parameter. The idea was that for now simple calculate method will be
  # enough, though if module will have a need to grow in the future, then it
  # would be easy to simply add other method, like custom_calculate etc. Or we
  # could go even more magic way and accept calculation strategy as a parameter
  # and form custom calculator instance to do the job.
  def self.calculate(file_name)
    transactions = transactions_from(file_name)
    Calculator.new(transactions, MAIN_STRATEGY).basic_calculate
    Result.new(transactions, StdoutFormatter.new).output_result
  end

  def self.transactions_from(file_name)
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
  # providers and their data. IMO This alongside with .transactions_from method
  # should go into some configuration class or module, depending on the need,
  # if application grows. For now I decided to leave it here as it is not
  # completely clear where and how this application is planned to be used.
  def self.providers
    @providers ||= begin
      provider_config = Psych.load_file('config/providers.yml')
      provider_config.map do |short_name, sizes_with_prices|
        Provider.new(short_name, sizes_with_prices)
      end
    end
  end
end
