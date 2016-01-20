require_relative './statewide_test'
require_relative './data_formatter'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_reader :initial_testing_array, :unlinked_testing, :formatter

#key is #statewide_testing, method is statewide_test
  def initialize
    @initial_testing_array = []
    @unlinked_testing = []
    @formatter = DataFormatter.new
  end

  def load_data(request_hash) #take hash, return unlinked testing
    formatted = formatter.format_data(request_hash, :statewide_testing) #give hash to formatter, get back a hash of data
    add_data/create_new_statewide_test(formatted)#give hash to object
    unlinked_testing
  end





  def add_data(data_type, formatted_data, t_object)
    if t_object.data[data_type].nil?
      t_object.data[data_type] = formatted_data
    else
      t_object.data[data_type].merge!(formatted_data)
    end
  end

  def create_new_statewide_test(data, d_name)
    new_instance = StatewideTest.new(data)
    initial_testing_array << new_instance
    unlinked_testing << [d_name, new_instance]
  end

  def find_by_name(d_name)
    initial_testing_array.detect do |testing_instance|
      testing_instance.name.upcase == d_name.upcase
    end
  end
end


#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>