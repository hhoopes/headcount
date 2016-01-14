require 'minitest'
# require './test/test_helper'
require './lib/enrollment'
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
    # e = Enrollment.new
      e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.268, e.truncate_float(0.2677)
    assert_equal 0.0, e.truncate_float(0.0000)
    assert_equal 1.0, e.truncate_float(1)
  end

  def test_kindergarten_participation_by_year_returns_single_hash_with_data
    e = Enrollment.new({:name => "Snort Splat", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677, 2006 => 0.523, 1800 => 0.325}})

    result = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677, 2006=>0.523, 1800=>0.325}

    assert_equal result, e.kindergarten_participation
  end
end
