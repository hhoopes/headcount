require "csv"
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require 'pry'

class DistrictRepository
  attr_reader :initial_districts_array, :enrollment_repo, :testing_repo, :economic_repo

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
    # data_category = request_hash.keys.first
    request_hash.each do |data_category, value|
      # binding.pry
      case data_category
      when :enrollment
        d_bundle = enrollment_repo.load_data(data_category => value)
        catalog_repos(d_bundle, data_category)
      when :statewide_testing
        d_bundle = testing_repo.load_data(data_category => value)
        catalog_repos(d_bundle, data_category)
      when :economic_profile
        d_bundle = economic_repo.load_data(data_category => value)
        catalog_repos(d_bundle, data_category)
      end

    end
  end

  def catalog_repos(d_bundle, data_category)
    d_bundle.each do |array_pair|
      d_name = array_pair.first
      data_object = array_pair.last
    existing_d_object = find_by_name(d_name)
      if existing_d_object
        existing_d_object.link_data(data_object, data_category)
      else
        new_district = District.new({:name => d_name})
        new_district.link_data(data_object, data_category)
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

  def find_by_name(d_name)
    initial_districts_array.detect do |district_instance|
      district_instance.name == d_name.upcase
    end
  end

  def find_all_matching(search_string)
    results = []
    initial_districts_array.each do |district|
      results << district.name if district.name.upcase.include?(search_string.upcase)
    end
    results
  end

end
