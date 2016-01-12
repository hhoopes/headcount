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
    string.gsub(/\s\W/, "").to_sym
  end

  def find_by_name(district)
    district_symbol = form(district)
    districts.each do |key, value|
      binding.pry
      if key == district_symbol

        value
      else nil
      end
    end
    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching(search)
    #returns either [] or one or more matches which contain the supplied name fragment, case insensitive
  end
end



#FOR ITERATION 1:
#Instead of loading just one data file , we now want to specify the data directory and have it figure out what data it wants/needs:
# dr = DistrictRepository.new
# dr.load_data({ :enrollment => {  :kindergarten => "./data/Kindergartners in full-day program.csv" }})
# district = dr.find_by_name("ACADEMY 20")
#When DistrictRepository created, automatically creates EnrollmentRepository. Allows us to access enrollment data for district.
#district.enrollment.kindergarten_participation_in_year(2010) # => 0.391
