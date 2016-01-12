$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "csv"
require 'district'

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
      concatenated = form(district)
      @districts[concatenated] = District.new({:name => district})
    end
  end

  def get_data_info(data)
    info = {}
    data.each do |key, value|
      info[:data_category] = key
      value.each do |key, value|
        info[:data_type] = key
        info[:file] = value
      end
    end
    info
  end

  def form(string)
    string.gsub(/\s\W/, "").upcase.to_sym
    #this gets rid of colons but not dashes, commas or spaces
    #my suggestion:
    #string.gsub(/\W/, "").upcase.to_sym
  end

  def find_by_name(district)
    district_symbol = form(district)
    districts.detect do |key, value|
      if key == district_symbol
        #that specific instance of value
        key
      else nil
      end
    end
    #is this case sensitive
    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching(search)
    search_output = []
    #returns either [] or one or more matches which contain the supplied name fragment, case insensitive
    # binding.pry
    search_symbol = form(search)
    search_string = search_symbol.to_s
    districts.find_all do |key, value|
      #compare string to string or symbol to symbol
      #make key to string
      if key.to_s.include?(search_string)
        search_output << key.to_s
      end
    end
    search_output
  end

end



#FOR ITERATION 1:
#Instead of loading just one data file , we now want to specify the data directory and have it figure out what data it wants/needs:
# dr = DistrictRepository.new
# dr.load_data({ :enrollment => {  :kindergarten => "./data/Kindergartners in full-day program.csv" }})
# district = dr.find_by_name("ACADEMY 20")
#When DistrictRepository created, automatically creates EnrollmentRepository. Allows us to access enrollment data for district.
#district.enrollment.kindergarten_participation_in_year(2010) # => 0.391
