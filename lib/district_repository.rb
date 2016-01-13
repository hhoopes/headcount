$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "csv"
require 'district'
require 'pry'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = []
  end

  def load_data(data)
     data_csv = parse_file(data)
     district = data_assignment(data_csv)
     new_districts(district)
    end

  def parse_file(data)
    data_info = get_data_info(data)
    CSV.open data_info.fetch(:file), headers: true, header_converters: :symbol
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

  def data_assignment(data_csv)
    data_csv.each do |row|
     district = row[:location]
     end
   end

  def new_districts(district)
    @districts << District.new({:name => district})
    #assigning new objects of district for each district name
  end

  # def form_symbol(string)
  #   string.gsub(/\W/, "").upcase.to_sym
  # end

  def find_by_name(search)
    if districts.has_key?(search)
      districts.fetch(search)
    else nil
    end
    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching(search)
    search_results = []
    districts.each do |key, value|
      if value.name.include?(search.upcase)
          search_results << value.name
        end
      end
    search_results
  end

end



#FOR ITERATION 1:
#Instead of loading just one data file , we now want to specify the data directory and have it figure out what data it wants/needs:
# dr = DistrictRepository.new
# dr.load_data({ :enrollment => {  :kindergarten => "./data/Kindergartners in full-day program.csv" }})


# district = dr.find_by_name("ACADEMY 20")
#When DistrictRepository created, automatically creates EnrollmentRepository. Allows us to access enrollment data for district.
#district.enrollment.kindergarten_participation_in_year(2010) # => 0.391
