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

meta trend:true
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
meta two:true
  def test_kindergarten_participation_against_hs_graduation_for_a_district_gives_correct_number
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

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_shows_if_hs_graduation_has_correlation_for_one_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_shows_false_if_there_is_no_correlation_with_district_and_state
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'FAKE ISD')
  end

  def test_shows_false_if_there_is_no_correlation_with_district_and_another_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'FAKE ISD')
  end

  def test_whether_kindergarten_participation_correlates_with_hs_graduation
    skip
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/subsets/kindergarten_enrollment.csv", :high_school_graduation => "./data/subsets/high_school_enrollment.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
    :across => ['ACADEMY 20', 'CANON CITY RE-1', 'CENTENNIAL R-1', 'CENTER 26 JT'])
  end

  def test_top_statewide_test_with_no_grade_raises_error
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
   #how does headcount_analyst get data? binding.pry doesn't show any info getting passed in
    ha = HeadcountAnalyst.new(dr)
    assert_raises InsufficientInformationError, "A grade must be provided to answer this question" do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end

  end
meta grade: true
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

    def test_get_error_if_unknown_grade_passed_in_for_12th_grade
      skip
      dr = DistrictRepository.new
      dr.load_data({
        :statewide_testing => {
          :third_grade => "./data/subsets/third_grade_proficient.csv",
          :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha = HeadcountAnalyst.new(dr)
      assert_raises UnknownDataError, "#{grade} is not a known grade" do
        ha.top_statewide_test_year_over_year_growth(grade: 12, subject: :math)
      end
    end

  def test_can_specify_a_top_amount_of_leaders_and_return_data
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
 #change data on assert_equal once get output
    ha = HeadcountAnalyst.new(dr)
    assert_equal ['top', 0.123], ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

    def test_can_specify_a_top_amount_of_leaders_and_return_data_for_8th_grade
      skip
      dr = DistrictRepository.new
      dr.load_data({
        :statewide_testing => {
          :third_grade => "./data/subsets/third_grade_proficient.csv",
          :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
   #change data on assert_equal once get output
      ha = HeadcountAnalyst.new(dr)
      assert_equal ['top', 0.123], ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
    end

  def test_if_grade_not_included_will_give_error
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    assert_raises InsufficientInformationError, "A grade must be provided to answer this question" do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_can_specify_an_average_of_all_grades
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    assert_equal ['top', 0.123, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)]
  end

  def test_given_grade_subject_returns_single_leader_and_average_percentage_growth
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    ha = HeadcountAnalyst.new(dr)
    winner = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ['top', 123.45], winner
  end

  def test_can_give_multiple_leaders
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

      assert_equal [['top district name', growth_1], ['second district name', growth_2], ['third district name', growth_3]], ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
  end

  def test_can_show_growth_across_all_three_subjects
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    assert_equal ['the top district name', 0.111], ha.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_weighted_grades_add_up_to_1
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
    assert_equal 1, weight_1 + weight_2 + weight_3
  end

  def test_can_weight_grades_in_creating_top_district
    skip
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})

    assert_equal ['the top district name', 0.111],  ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
  end

end
