require "csv"
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_testing_repository'
require_relative 'economic_profile_repository'
require 'pry'

class DistrictRepository
  attr_reader :initial_districts_array, :enrollment_repo, :testing_repo, :testing_repo

  def initialize(district_names = [])
    @initial_districts_array = []

    district_names.each do |name|
      create_district_from_array name
    end

    @testing_repo = StatewideTestingRepository.new
    @economic_repo = EconomicProfileRepository.new
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(request_hash)
    request_hash.each do | key, value |
      case key
        when :enrollment
          d_list = enrollment_repo.load_enrollment(request_hash.fetch(:enrollment))
        when :statewide_testing
          d_list = testing_repo.load_enrollment(request_hash.fetch(:statewide_testing))
        when :economic_profile
          d_list = economic_repo.load_enrollment(request_hash.fetch(:economic_profile))
      end
      catalog_repos(d_list, key)
    end
  end

  def catalog_repos(d_list, key)
    d_list.each do |array_pair|
      d_name = array_pair.first
      d_object = array_pair.last

    existing_d_object = find_by_name(d_name)
      if existing_d_object
        existing_d_object.enrollment = d_object
      else
        new_district = District.new({:name => d_name, :enrollment => d_object})
        initial_districts_array << new_district
      end
    end
  end

  def create_district_from_array(d_name)
    d_name = d_name.upcase
    if find_by_name(d_name)
      return
    else
      initial_districts_array << District.new({:name => d_name})
    end
  end

  def create_relationship(d_object)
    d_object.enrollment = enrollment_repo.find_by_name(d_object.name)
  end

  def find_by_name(d_name)
    initial_districts_array.detect do |district_instance|
      district_instance.name == d_name.upcase
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

# enrollment_repo.names.each do |d_name|
#   ensure_district_exists d_name
# end
# initial_districts_array
# end
