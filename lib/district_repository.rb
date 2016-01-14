require "csv"
require_relative 'district'
require_relative 'enrollment_repository'
require 'pry'

class DistrictRepository
  attr_reader :initial_districts_array, :enrollment_repo

  def initialize
    @initial_districts_array = []
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(request_with_file_and_data_info)
    enrollment_repo.load_data(request_with_file_and_data_info)
    enrollment_repo.names.each do |d_name|
      ensure_district_exists d_name
    end
    initial_districts_array
  end

  def ensure_district_exists(d_name)
    if find_by_name(d_name)
      return
    else
      initial_districts_array << District.new({:name => d_name})
    end
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
