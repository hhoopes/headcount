$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "csv"
require 'district'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}

  end

  def load_data
    data = CSV.open "./data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol
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

# kindergarten_data = CSV.open "./data/Kindergartners in full-day program.csv", headers: true, header_converters: :symbol
# kindergarten_data.each do |row|
#   district = row[:location]
#   puts district
# end
# ({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# district = dr.find_by_name("ACADEMY 20")
