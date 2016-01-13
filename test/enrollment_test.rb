
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'minitest'
# require './test/test_helper'
require 'enrollment'
require 'pry'

class EnrollmentTest < Minitest::Test

  def test_instantiates_an_enrollment_class
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert e.instance_of?(Enrollment)
  end

  def test_enrollment_has_a_method_that_returns_district_name
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "ACADEMY 20", e.name
  end

  def test_enrollment_data_is_truncated_at_3_decimals
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    num =  e.kindergarten_participation_by_year
​
    assert num.to_s.split(".")[1].length < 4
  end
end
