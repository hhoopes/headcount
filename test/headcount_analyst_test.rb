require 'minitest'
require './lib/headcount_analyst'
require './lib/district_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_new_headcount_analyst_requires_instance_of_district_repo
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert ha.instance_of? HeadcountAnalyst
  end

  def test_kindergarten_participation_rate_variation_takes_input_of_district_and_state_and_gives_variance
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
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
        :kindergarten => "./data/subsets/kindergarten_enrollment.csv",
        :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_statewide_kindergarten_participation_doesnt_coorelate_with_statewide_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv", :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_shows_if_hs_graduation_has_correlation_for_one_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

meta fail: true
  def test_shows_false_if_there_is_no_correlation_for_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'CANON CITY RE-1')
  end

  def test_whether_kindergarten_participation_correlates_with_hs_graduation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(
    :across => ['ACADEMY 20', 'CANON CITY RE-1', 'CENTENNIAL R-1', 'CENTER 26 JT'])
  end

  def test_top_statewide_test_with_no_grade_raises_error
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_raises InsufficientInformationError, "A grade must be provided to answer this question" do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_get_error_if_unknown_grade_passed_in
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_raises UnknownDataError, "9 is not a known grade" do
      ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
    end
  end

  def test_can_specify_a_top_amount_of_leaders_and_return_data
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["COLORADO", 0.003], ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_can_specify_a_top_leaders_and_return_data_for_8th_grade
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["BUENA VISTA R-31", 0.028], ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
  end

  def test_if_grade_not_included_will_give_error
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_raises InsufficientInformationError, "A grade must be provided to answer this question" do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_can_specify_a_top_leader_for_an_average_of_all_subjects
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["BETHUNE R-5", 0.049], ha.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_can_give_multiple_leaders
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal [["ACADEMY 20", -0.004], ["CANON CITY RE-1", 0.001], ["COLORADO", 0.003]], ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
  end

  def test_weighted_grades_add_up_to_1
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    ha = HeadcountAnalyst.new(dr)
    assert_raises IncorrectDataError, "Please make sure weights add up to 1" do
      ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.1})
    end
  end

  def test_weighting_scores_with_only_two_districts_and_mismatched_years_and_mismatched_subjects_returns_correct_values
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_tiny.csv"}})
    ha = HeadcountAnalyst.new(dr)
  end

  def test_can_weight_grades_in_creating_top_district
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["BRIGHTON 27J", 0.016],  ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
  end

  def test_generate_hash_of_statewide_data_for_each_result_set_type_that_can_be_accessed_later
    dr = DistrictRepository.new
    dr.load_data({
        :economic_profile => {
          :median_household_income => "./data/subsets/median_household.csv",
          :free_or_reduced_price_lunch => "./data/subsets/free_or_red_price_lunch.csv",
          :children_in_poverty => "./data/subsets/children_in_pov.csv"},
        :enrollment => {
          :high_school_graduation => "./data/subsets/high_school_enrollment.csv"
        }})
    ha = HeadcountAnalyst.new(dr)
    assert ha.statewide_averages.empty?
    ha.generate_state_results(:children_in_poverty_rate)
    ha.generate_state_results(:median_household_income)
    ha.generate_state_results(:free_or_reduced_price_lunch_rate)
    ha.generate_state_results(:high_school_graduation_rate)
    refute ha.statewide_averages.empty?
    assert_in_delta 0.167, ha.statewide_averages.fetch(:children_in_poverty_rate), 0.005
    assert_in_delta 57408, ha.statewide_averages.fetch(:median_household_income), 0.005
    assert_in_delta 0.138, ha.statewide_averages.fetch(:free_or_reduced_price_lunch_rate), 0.005
    assert_in_delta 0.751, ha.statewide_averages.fetch(:high_school_graduation_rate), 0.005
  end
end

class KindergartenParticipationAgainstIncomeTest < Minitest::Test

meta ha:true
  def test_kindergarten_participation_against_household_income_for_a_district_provides_coorelation
    ha = headcount_analyst_for_kp_and_hi
    assert_equal 0.766, ha.kindergarten_participation_against_household_income('ACADEMY 20')
  end
meta haf:true
  def test_statewide_kindergarten_participation_doesnt_coorelate_with_statewide_graduation
    ha = headcount_analyst_for_kp_and_hi
    assert ha.kindergarten_participation_correlates_with_household_income(for: 'STATEWIDE')
  end
meta ha:true
  def test_shows_if_hs_graduation_has_correlation_for_one_district
    ha = headcount_analyst_for_kp_and_hi
    assert ha.kindergarten_participation_correlates_with_household_income(for: 'Academy 20')
  end
meta ha:true
  def test_whether_kindergarten_participation_correlates_with_income_variation_across_multiple_districts
    ha = headcount_analyst_for_kp_and_hi

    refute ha.kindergarten_participation_correlates_with_household_income(
    :across => ['ACADEMY 20', 'CANON CITY RE-1', 'CENTENNIAL R-1', 'CENTER 26 JT'])
  end

  def headcount_analyst_for_kp_and_hi
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
          :kindergarten => "./data/subsets/kindergarten_enrollment.csv"},
        :economic_profile => {
          :median_household_income => "./data/subsets/median_household.csv"}})
    ha = HeadcountAnalyst.new(dr)
  end
end
