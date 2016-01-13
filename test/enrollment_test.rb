
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





end
