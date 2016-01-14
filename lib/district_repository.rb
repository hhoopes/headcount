require "csv"
require_relative 'district'
require 'pry'

class DistrictRepository
  attr_reader :initial_districts_array

  def initialize
    @initial_districts_array = []
  end

  def load_data(request_with_file_and_data_info)
     data_csv = parse_file(request_with_file_and_data_info)
     district_names = data_assignment(data_csv)
     add_new_district_to_array(district_names)
    end

    def parse_file(request_with_file_and_data_info)
      CSV.open request_with_file_and_data_info[:enrollment][:kindergarten], headers: true,header_converters: :symbol
    end

    def data_assignment(data_csv)
      data_csv.map do |row|
        row[:location]
      end.uniq
    end

  def add_new_district_to_array(district_names)
    district_names.each do |d_name|
      if find_by_name(d_name)
        next
      else
        initial_districts_array << District.new({:name =>
        d_name})
      end
    end
    initial_districts_array
  end

  def find_by_name(d_name)
    initial_districts_array.detect do |district_instance|
      district_instance.name.upcase == d_name.upcase
    end
  end

  def find_all_matching(search_string)
    search_results_array = []
    initial_districts_array.each do |district|
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
