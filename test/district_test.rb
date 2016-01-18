require 'minitest'
# require 'test/test_helper'
require_relative '../lib/district'
require 'pry'

class DistrictTest < Minitest::Test

  def test_can_instantiate_district_object_with_name_data
    d = District.new({:name =>"ACADEMY 20"})
    assert d.instance_of?(District)
  end

  def test_instantiate_district_object_with_name_data_with_upcase
    d = District.new({:name =>"academy 20"})
    assert_equal "ACADEMY 20", d.name
  end

  def test_district_can_link_data_objects_to_itself
    d = District.new({:name =>"academy 20"})
    refute d.enrollment
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    d.link_data(e, :enrollment)
    hash = {2010=>0.391, 2011=>0.353, 2012=>0.267}
    assert d.enrollment
    assert_equal hash, d.enrollment.kindergarten_participation_by_year
  end

end
