require_relative './economic_profile'
require_relative './district_repository'
require 'csv'
require 'pry'

class EconomicProfileRepository
  attr_reader :initial_eco_array

  def initialize
    @initial_eco_array = []
  end
#based on load_data in district repo, the first key of request_hash is gone
  def load_data(request_hash)
	    request_hash.fetch(:economic_profile).each do | data_category, file|
    	load_enrollment(data_category, file)
    end
    # key_and_file = get_key_and_file(request_hash)
    # load_enrollment(key_and_file)
  end

  def get_key_and_file(hash)
    hash.map do | key, value|
    hash.fetch(key)
    end
    #assign labels that can be used later
    #finds value with the key, data_category
  end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

  def load_enrollment(data_category, file)
    d_bundle = []
    data_csv = parse_file(file)
    data_csv.each do |row|
      d_name = row[:location]
      data = row[:data]
      year = row[:timeframe]

      if find_by_name(d_name)
        d_object = find_by_name(d_name)


        d_object.economic_profile.merge!({key => {year => data})

          # d_object.enrollment[:kindergarten_participation] = {year => data}
      else
        new_instance = EconomicProfile.new({
          :name => d_name,
          :data_category => { year => data }
          })
          #method if this is the key this is the data category
        @initial_eco_array << new_instance
        d_bundle << [d_name, new_instance]
      end
    end
    d_bundle
  end
#district.economic_profile.key => data
  def find_by_name(d_name)
    initial_eco_array.detect do |eco_instance|
      eco_instance.name.upcase == d_name.upcase
    end
  end
#organizes the data by assigning each data file to a key and thus creating a hash
end
# functionality is that it will use a filter to find specific enrollment information. In this case, info about Academy 20's kindergarten enrollment for all years

#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
