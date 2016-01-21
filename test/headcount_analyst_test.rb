require 'minitest'
# require 'test/test_helper'
require './lib/headcount_analyst'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_new_headcount_analyst_requires_instance_of_district_repo
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert ha.instance_of? HeadcountAnalyst
  end

  def test_kindergarten_participation_rate_variation_takes_input_of_district_and_state_and_gives_variance
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)
    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.766, variation
  end

  def test_kindergarten_participation_rate_variation_takes_input_of_2_districts_and_gives_variance
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)
    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'CENTENNIAL R-1')
    assert_equal 0.625, variation
  end

  def test_kindergarten_participation_rate_variation_takes_input_of_2_districts_and_gives_variance_with_different_school
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'BRUSH RE-2(J)')
    assert_equal 0.638, variation
  end

  def test_kindergarten_participation_rate_variation_trend_tests_for_the_variation_each_year
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)
    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    expected = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}
    actual.values.zip(expected.values).each do | pair|

      assert_in_delta pair.last, pair.first, 0.005
    end
  end

  def test_kindergarten_participation_against_hs_graduation_for_a_district_gives_correct_number
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
        :kindergarten => "./data/subsets/kindergarten_enrollment.csv",
        :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_shows_if_hs_graduation_has_correlation_for_statewide
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_shows_if_hs_graduation_has_correlation_for_one_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_shows_false_if_there_is_no_correlation_with_district_and_state
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'FAKE ISD')
  end

  def test_shows_false_if_there_is_no_correlation_with_district_and_another_district
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'FAKE ISD')
  end

  def test_whether_kindergarten_participation_correlates_with_hs_graduation
   dr = DistrictRepository.new
   dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
   ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
    :across => ['ACADEMY 20', 'CANON CITY RE-1', 'CENTENNIAL R-1', 'CENTER 26 JT'])
  end


  def test_top_statewide_test_with_no_grade_raises_two_kinds_of_errors
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    ha = HeadcountAnalyst.new(dr)
    assert_raises InsufficientInformationError do
      ha.top_statewide_test_year_over_year_growth()
    end
    assert_raises UnknownDataError do
      ha.top_statewide_test_year_over_year_growth(grade: 10)
    end
  end

meta current:true

  def test_can_specify_a_top_amount_of_leaders_and_return_data
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    ha = HeadcountAnalyst.new(dr)
    ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_can_specify_an_average_of_all_grades
  end

  def test_given_grade_subject_returns_single_leader_and_average_percentage_growth
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    ha = HeadcountAnalyst.new(dr)
    winner = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal [], winner
  end

  def test_weighted_grades_add_up_to_1

  end

  def test_can_weight_grades_in_creating_top_district
  end



end
