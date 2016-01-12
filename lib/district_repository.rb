$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "csv"
require 'district'
require 'pry'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data(data)
    data_info = get_data_info(data)
    data_csv = CSV.open data_info.fetch(:file), headers: true, header_converters: :symbol
    data_csv.each do |row|
      district = row[:location]
      symbol = form_symbol(district)
      @districts[symbol] = District.new({:name => district})
      #eventually change symbol and the initialization to an if statement based on get_data_info
    end

  end

  def get_data_info(argument)
    #get file and category info out of load_data calls
    info = {}
    argument.each do |key, value|
      info[:data_category] = key
      value.each do |key, value|
        info[:data_type] = key
        info[:file] = value
      end
    end
    info
  end

  def form_symbol(string)
    string.gsub(/\W/, "").upcase.to_sym
    # binding.pry

  end
  def find_by_name(search)
    search_symbol = form_symbol(search)
    if districts.has_key?(search_symbol)
      districts.fetch(search_symbol)
    else nil
    end

    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching(search)
    search_output = []
    formatted_search = search.gsub(/\W/, "").upcase
    districts.find_all do |key, value|
      if key.to_s.include?(formatted_search)
        search_output << value.name
      end
    end
    search_output
  end

end



#FOR ITERATION 1:
#Instead of loading just one data file , we now want to specify the data directory and have it figure out what data it wants/needs:
dr = DistrictRepository.new
dr.load_data({ :enrollment => {  :kindergarten => "./data/Kindergartners in full-day program.csv" }})

# district = dr.find_by_name("ACADEMY 20")
#When DistrictRepository created, automatically creates EnrollmentRepository. Allows us to access enrollment data for district.
#district.enrollment.kindergarten_participation_in_year(2010) # => 0.391
