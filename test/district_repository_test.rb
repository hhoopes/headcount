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

  def test_load_data_method_takes_csv_and_creates_district_instance
    skip
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    assert output.instance_of?(District)
  end

  def test_find_by_name_returns_nil_for_district_in_repo
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    find_by_name_output = dr.find_by_name("Marshmallows")
    assert_nil find_by_name_output
  end

  def test_find_by_name_returns_name_for_district_in_repo
    dr = DistrictRepository.new
    output = dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    find_by_name_output = dr.find_by_name("Aspen 1")
    assert_equal "Aspen 1", find_by_name_output
  end

end
