require_relative './statewide_test'
require_relative './data_formatter'
require 'csv'
require 'pry'

class StatewideTestRepositoryB
  attr_reader :initial_testing_array, :unlinked_testing, :formatter

#key is #statewide_testing, method is statewide_test
  def initialize
    @initial_testing_array = []
    @unlinked_testing = []
    @formatter = DataFormatter.new
  end

  def load_data(request_hash) #take hash, return unlinked testing
    request_hash.fetch(:statewide_testing).each do | data_type, file |
      formatted = formatter.format_data(data_type, file) #give hash to formatter, get back a hash of data
      sort_data(formatted)
      unlinked_testing
    end
  end

  def sort_data(formatted)
    formatted.each do |hash|
      data_type       = hash.first
      location        = hash[1]
      formatted_hash  = hash.last
      t_object = find_by_name(location)
      if t_object
        add_data(formatted_hash, t_object, data_type)
      else
        create_new_instance(formatted_hash, location, data_type)
      end
    end
    binding.pry
  end

  def add_data(hash, t_object, data_type)

    if t_object.data[data_type].nil?
      t_object.data[data_type] = hash
    else
      if t_object.data[data_type].fetch(:year).nil?
      t_object.data[data_type].merge!(hash)
    end
  end

  def create_new_instance(hash, location, data_type)
    new_instance = StatewideTest.new({:name => location, data_type => hash})
    initial_testing_array << new_instance
    unlinked_testing << [location, new_instance]
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
