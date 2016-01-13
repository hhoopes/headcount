require 'minitest'
# require 'test/test_helper'
require_relative '../lib/district'
require 'pry'

class DistrictTest < Minitest::Test

  def test_can_instantiate_district_object_with_name_data
    d = District.new({:name=>"ACADEMY 20"})
    assert d.instance_of?(District)
  end

  def test_instantiate_district_object_with_name_data_with_upcase
    d = District.new({:name =>"academy 20"})
    assert_equal "academy 20".upcase, d.name
  end
end
