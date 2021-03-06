require_relative './statewide_test'
require_relative './data_formatter'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_reader :initial_testing_array, :unlinked_testing, :formatter

  def initialize
    @initial_testing_array = []
    @unlinked_testing = []
    @formatter = DataFormatter.new

  def load_data(request_hash)
    request_hash.fetch(:statewide_testing).each do | data_type, file |
      load_testing(data_type, file)
    end
    unlinked_testing
  end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

  def load_testing(data_type, file)
    data_csv = parse_file(file)
    data_csv.each do |row|
      d_name = row[:location].upcase
      percent = row[:data]
      year = row[:timeframe].to_i
      subject = row[:score].to_s

      return if formatter.exclude_data.include?(percent)

        formatted_data = {subject => percent}

        t_object = find_by_name(d_name)
        if t_object
          add_data(year, data_type, formatted_data, t_object)
        else
          create_new_statewide_test(formatted_data, d_name, year, data_type)
        end
      end
    end
  end

  def add_data(year, data_type, formatted_data, t_object)
    if t_object.data[data_type].nil?
      t_object.data[data_type] = {year => formatted_data}
    else
      if t_object.data[data_type][year].nil?
        t_object.data[data_type].merge!({year => formatted_data})
      else
        t_object.data[data_type][year].merge!(formatted_data)
      end
    end
  end

  def create_new_statewide_test(formatted_data, d_name, year, data_type)
    new_instance = StatewideTest.new({:name=> d_name, data_type => {year => formatted_data}})
    initial_testing_array << new_instance
    unlinked_testing << [d_name, new_instance]
  end

  def find_by_name(d_name)
    initial_testing_array.detect do |testing_instance|
      testing_instance.name.upcase == d_name.upcase
    end
  end


end
