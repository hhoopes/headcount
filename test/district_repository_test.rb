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
    assert dr.enrollment.instance_of? EnrollmentRepository

  end

  def test_load_data_takes_a_data_request_and_returns_an_array_of_district_instances_and_names
    dr = DistrictRepository.new
    array = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    popped_element = array.pop
    assert popped_element.instance_of?(District)
  end

  def test_parse_file_returns_an_instance_of_CSV
    dr = DistrictRepository.new
    parsed = dr.parse_file(:enrollment=>{:kindergarten=>"./data/subsets/kindergarten_enrollment.csv"})
    assert parsed.instance_of?(CSV)
  end

  def test_assign_data_returns_an_array_of_district_names
    dr = DistrictRepository.new
    names = dr.data_assignment([
      {location: 'a'},
      {location: 'b'},
      {location: 'a'},
    ])
    assert_equal ['a', 'b'], names
  end

  def test_loading_district_to_repo_adds_it_to_array
    dr = DistrictRepository.new
    assert dr.initial_districts_array.empty?
    output1 = dr.add_new_district_to_array(["Colorado"])
    assert_equal 1, dr.initial_districts_array.length

    output2 = dr.add_new_district_to_array(["ACADEMY 20"])

    assert_equal 2, dr.initial_districts_array.length
  end

  def test_loading_district_overwrites_same_name
    dr = DistrictRepository.new
    output1 = dr.add_new_district_to_array(["Colorado"])
    assert_equal 1, dr.initial_districts_array.length

    output2 = dr.add_new_district_to_array(["Colorado"])

    assert_equal 1, dr.initial_districts_array.length
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
