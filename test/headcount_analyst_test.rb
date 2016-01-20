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

  meta ha:true
  def test_kindergarten_participation_rate_variation_takes_input_of_2_districts_and_returns_variance
    dr = DistrictRepository.new
    dr.load_data({:enrollment => { :kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.766, variation
  end

  def test_kindergarten_participation_rate_variation_trend_tests_for_the_variation_each_year
    # skip
      dr = DistrictRepository.new
      dr.load_data({:enrollment => { :kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
      ha = HeadcountAnalyst.new(dr)

      variation = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
      variation_hash = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}
      assert_equal variation_hash, variation
  end

  # meta ha:true
  def test_kindergarten_participation_against_hs_graduation_for_two_districts_gives_correct_number
    # skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 1.234, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_shows_if_hs_graduation_has_correlation_for_two_districts
    #  skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergarteners in full-day program.csv", :high_school_graduation => "./data/High school graduatio rates.csv"}})
    ha = HeadcountAnalyst.new(dr)
    #this probably doesn't work but somehow is passing
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

    def test_shows_if_hs_graduation_has_correlation_for_two_districts
      skip
      dr = DistrictRepository.new
      dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
      ha = HeadcountAnalyst.new(dr)

      assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    end

    def test_shows_false_if_there_is_no_correlation
      skip
      dr = DistrictRepository.new
      dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
      ha = HeadcountAnalyst.new(dr)
      #might not be refute but hoping to find something that does give me a refute
      refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'CENTENNIAL')
    end

    def test_whether_kindergarten_participation_correlates_with_hs_graduation
      skip
     dr = DistrictRepository.new
     dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
     ha = HeadcountAnalyst.new(dr)

      assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :across => ['ACADEMY 20', 'CANON CITY RE-1', 'CENTENNIAL', 'CENTER 26 JT'])
    end


end
