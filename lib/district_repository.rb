require "csv"
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require 'pry'

class DistrictRepository
  attr_reader :initial_districts_array, :enrollment_repo, :testing_repo

  def initialize(district_names = [])
    @initial_districts_array = []

    district_names.each do |name|
      create_district_from_array name
    end

    @testing_repo = StatewideTestRepository.new
    @economic_repo = EconomicProfileRepository.new
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(request_hash)
    data_category = request_hash.keys.first
    case data_category #decide which repo is responsible for new data. "Each" allows any and all required repos to get processed
      when :enrollment
        d_bundle = enrollment_repo.load_data(request_hash)
        catalog_repos(d_bundle, data_category)
        # create_relationships(data_category)
      when :statewide_testing
        d_bundle = testing_repo.load_data(request_hash)
        catalog_repos(d_bundle, data_category)
        # create_relationships(data_category)
      when :economic_profile
        d_bundle = economic_repo.load_data(request_hash)
        catalog_repos(d_bundle, data_category)
        # create_relationships(data_category)
      end

  end

  # def create_relationships(data_category)
  #   initial_districts_array.each do |district|
  #     district.enrollment     = er.find_by_name(district.name)


  def catalog_repos(d_bundle, data_category) # d_bundle comes from the other repos to associate new districts with their data
    d_bundle.each do |array_pair|  #key will be refactored in to link districts to the correct repos
      d_name = array_pair.first #take the name from the array
      data_object = array_pair.last #take the object from the array

    existing_d_object = find_by_name(d_name) #look up a district object from the name you get
      if existing_d_object
        existing_d_object.link_data(data_object, data_category)
        binding.pry
        # existing_d_object.enrollment = d_object #set its enrollment to the enrollment object we got handed
      else
        new_district = District.new({:name => d_name})
        new_district.enrollment = data_object #give new district the data object
        initial_districts_array << new_district #create the district and add it to our array
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
