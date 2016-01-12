$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "csv"
require 'district'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data
    data = CSV.open "../data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol
    #i changed directory path from ./ to ../ because wouldn't work otherwise on my computer. heads up in case you get an error 
    data.each do |row|
      district = row[:location]
      @districts[district.to_sym] = District.new({:name => district})
      binding.pry
      puts districts
    end
  end

  def find_by_name(district)
    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching(search)
    #returns either [] or one or more matches which contain the supplied name fragment, case insensitive
  end
end

dr = DistrictRepository.new
dr.load_data


#FOR ITERATION 1:
#Instead of loading just one data file , we now want to specify the data directory and have it figure out what data it wants/needs:
# dr = DistrictRepository.new
# dr.load_data({ :enrollment => {  :kindergarten => "./data/Kindergartners in full-day program.csv" }})
# district = dr.find_by_name("ACADEMY 20")
#When DistrictRepository created, automatically creates EnrollmentRepository. Allows us to access enrollment data for district.
#district.enrollment.kindergarten_participation_in_year(2010) # => 0.391
