require "csv"
require_relative 'district'
require 'pry'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = []
  end

  def load_data(request) #new instances of district start here
     data_csv = parse_file(request)
     district_names = data_assignment(data_csv)
     new_districts(district_names)
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
      #  binding.pry
      #busted: no output
    data_csv.map do |row|
      row[:location]
    end.uniq
  end

  def new_districts(district_names)
    #busted. we needed to iterate through each name in the array and pass it in
    district_names.each do |d_name|
      if find_by_name(d_name)
        next
      else
        @districts << District.new({:name =>
        d_name})
      end
    end
    #assigning new objects of district for each district name
  end

  # def form_symbol(string)
  #   string.gsub(/\W/, "").upcase.to_sym
  # end

  def find_by_name(d_name)
    districts.detect do |district_instance|
      district_instance.name.upcase == d_name.upcase
    end
    #returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching(search_string)
    search_results_array = []
    districts.each do |district|
      if district.name.include?(search_string.upcase)
          search_results_array << district.name
        end
      end
    search_results_array
  end

end



#FOR ITERATION 1:
#Instead of loading just one data file , we now want to specify the data directory and have it figure out what data it wants/needs:
# dr = DistrictRepository.new
# dr.load_data({ :enrollment => {  :kindergarten => "./data/Kindergartners in full-day program.csv" }})


# district = dr.find_by_name("ACADEMY 20")
#When DistrictRepository created, automatically creates EnrollmentRepository. Allows us to access enrollment data for district.
#district.enrollment.kindergarten_participation_in_year(2010) # => 0.391
