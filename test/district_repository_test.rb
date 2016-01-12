$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'minitest'
require '../test/test_helper'
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

  
end
