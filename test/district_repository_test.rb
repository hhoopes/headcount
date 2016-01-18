require 'minitest'
# require './test/test_helper'
require './lib/district_repository'
require 'pry'

class DistrictRepositoryTest < Minitest::Test
  def test_instantiates_a_repository_class
    dr = DistrictRepository.new
    assert dr.instance_of?(DistrictRepository)
  end

  def test_instantiating_district_repo_also_creates_enrollment_repository
    dr = DistrictRepository.new
    assert dr.enrollment_repo.instance_of? EnrollmentRepository
  end

  def test_load_data_takes_a_data_request_and_returns_an_array_of_district_instances_and_names
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    district = dr.initial_districts_array.last
    assert district.instance_of?(District)
  end

  def test_can_load_district_from_array_of_data
    dr = DistrictRepository.new(["Colorado"])
    refute dr.initial_districts_array.empty?

    dr.create_district_from_array("District 520")
    assert_equal 2, dr.initial_districts_array.length
  end

  def test_find_by_name_returns_nil_for_query_not_in_repo
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    find_by_name_output = dr.find_by_name("Marshmallows")
    assert_nil find_by_name_output
  end

  def test_find_by_name_returns_district_object
    start = Time.now
    100.times do
      dr = DistrictRepository.new
      dr.load_data({
        :enrollment => {
          :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
        }
      })
      query = "Colorado"
      find_by_name_output = dr.find_by_name(query)

      assert find_by_name_output.instance_of?(District)
    end
    puts "TIME WITH CSVS: #{Time.now - start}s"
  end

  def test_find_by_name_returns_district_object_no_csvs
    start = Time.now
    100.times do
      dr = DistrictRepository.new(['Colorado', 'ACADEMY 20'])
      assert dr.find_by_name('Colorado').instance_of?(District)
      assert dr.find_by_name('ACADEMY 20').instance_of?(District)
      refute dr.find_by_name('ACADEMY 30').instance_of?(District)
    end
    puts "TIME WITHOUT CSVS: #{Time.now - start}s"
  end

  def test_find_by_name_with_funky_characters_still_returns_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })

    query = "ACADEMY 20"
    assert dr.find_by_name(query).instance_of?(District)
    assert_equal "ACADEMY 20", dr.find_by_name(query).name

    query = "BRUSH RE-2(J)"
    assert dr.find_by_name(query).instance_of?(District)
    assert_equal "BRUSH RE-2(J)", dr.find_by_name(query).name
  end

  def test_find_by_name_is_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
        :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    query ="brush RE-2(J)"

    assert_equal "BRUSH RE-2(J)", dr.find_by_name(query).name
  end


  def test_find_all_matching_returns_possible_district_options_for_fragment_search
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })

    assert_equal ["CENTENNIAL R-1", "CENTER 26 JT"], dr.find_all_matching("CEN")
  end


  def test_find_all_matching_returns_possible_district_options_for_fragment_search_lowercase
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })

    assert_equal ["CENTENNIAL R-1", "CENTER 26 JT"], dr.find_all_matching("cen")
  end

  def test_find_all_matching_returns_empty_array_if_no_matches
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })

    assert_equal [], dr.find_all_matching("XW")
  end

end
