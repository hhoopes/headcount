require 'minitest'
# require 'test/test_helper'
require 'headcount_analyst'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_new_headcount_analyst_requires_instance_of_district_repo
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert ha.instance_of? HeadcountAnalyst
  end
  # meta ha:true
  def test_kindergarten_participation_rate_variation_takes_input_of_2_districts_and_returns_variance
    dr = DistrictRepository.new
    dr.load_data({:enrollment => { :kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'CANON CITY RE-1')
    assert_equal 0.579, variation
  end

  def test_kindergarten_participation_rate_variation_trend_tests_for_the_variation_each_year
      dr = DistrictRepository.new
      dr.load_data({:enrollment => { :kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
      ha = HeadcountAnalyst.new(dr)

      variation = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
      variation_hash = {"2007"=>0.992, "2006"=>1.05, "2005"=>0.961, "2004"=>1.258, "2008"=>0.718, "2009"=>0.652, "2010"=>0.681, "2011"=>0.728, "2012"=>0.689, "2013"=>0.694, "2014"=>0.661}
      assert_equal variation_hash, variation
  end
end
