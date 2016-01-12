$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "csv"
require 'district'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data(data)
    file = file_name(data)
    category = data_category(data)
    type = data_type(data)
    binding.pry
    data_csv = CSV.open file, headers: true, header_converters: :symbol

    data_csv.each do |row|
      district = row[:location]
      @districts[district.to_sym] = District.new({:name => district})
    end
  end

  def data_category(data)
    data.keys.first
  end

  def data_type(data)
    data.values.keys
  end

  def file_name(data)
    binding.pry
    data.values.values
  end

  def find_by_name(district)
    @districts.fetch district
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
