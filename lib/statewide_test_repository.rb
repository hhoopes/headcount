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

  def load_data(request_hash) #entry point for directly creating a repo
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

  def load_testing(data_type, file) #entry point for district repo
    data_csv = parse_file(file)
    data_csv.each do |row|
      d_name = row[:location].upcase
      percent = row[:data]
      year = row[:timeframe].to_i
      subject = row[:score].to_s

      return if formatter.bad_data.include?(percent)
        # formatted_data = {:name => d_name, data_type => {year => {subject => percent}}}
        formatted_data = {subject => percent}

        t_object = find_by_name(d_name)
        if t_object
          add_data(year, data_type, formatted_data, t_object)
        else # district doesn't exist, create instance
          create_new_statewide_test(formatted_data, d_name, year, data_type)
        end
      end
    end
  end

  def add_data(year, data_type, formatted_data, t_object)
    if t_object.data[data_type].nil? #no data for that grade
      t_object.data[data_type] = {year => formatted_data}
    else
      if t_object.data[data_type][year].nil? #no data for that subject
        t_object.data[data_type].merge!({year => formatted_data})
      else
        t_object.data[data_type][year].merge!(formatted_data) #subject exists, merge other subjects
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


#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
