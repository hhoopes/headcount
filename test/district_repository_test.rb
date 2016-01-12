
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'minitest'
# require './test/test_helper'
require 'district_repository'
require 'pry'

class DistrictRepositoryTest < Minitest::Test

  def test_instantiates_a_repository_class
    repo = DistrictRepository.new
    assert repo.instance_of?(DistrictRepository)
  end

  def test_find_by_name_returns_nil_for_query_not_in_repo
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    find_by_name_output = dr.find_by_name("Marshmallows")
    assert_nil find_by_name_output
  end

  def test_data_in_and_out_is_santized_for_consistency_and_to_be_symbols
    dr = DistrictRepository.new
    assert_equal :_JAJA, dr.form_symbol("-_ jaJA")
    assert_equal :FFFF, dr.form_symbol("@FFff ++~")
    assert_equal :LOWERCASE, dr.form_symbol("lowercase")
  end

  def test_find_by_name_returns_district_object
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
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
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    query = "ACADEMY 20"
    assert dr.find_by_name(query).instance_of?(District)
    assert_equal "ACADEMY 20", dr.find_by_name(query).name

    query ="BRUSH RE-2(J)"
    assert dr.find_by_name(query).instance_of?(District)
    assert_equal "BRUSH RE-2(J)", dr.find_by_name(query).name
  end

  def test_find_by_name_is_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    query ="brush RE-2(J)"

    assert_equal "BRUSH RE-2(J)", dr.find_by_name(query).name
  end


  def test_find_all_matching_returns_possible_district_options_for_fragment_search
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert_equal ["CENTENNIAL R-1", "CENTER 26 JT"], dr.find_all_matching("CEN")
  end


    def test_find_all_matching_returns_possible_district_options_for_fragment_search_lowercase
      dr = DistrictRepository.new
      output = dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })

      assert_equal ["CENTENNIAL R-1", "CENTER 26 JT"], dr.find_all_matching("cen")
    end

    def test_find_all_matching_returns_empty_array_if_no_matches
      dr = DistrictRepository.new
      output = dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })

      assert_equal [], dr.find_all_matching("XW")
    end
end
