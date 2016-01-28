require 'minitest'
require './lib/headcount_analyst'
require './lib/result_entry'
require './lib/district_repository'
require 'pry'

class ResultSetTest < Minitest::Test

  def test_create_a_result_set_by_initializing_with_result_entries
    rs = ResultSet.new(matching_districts: [entry1], statewide_average: entry2)
    assert rs.instance_of? ResultSet
  end

  def test_result_set_responds_to_methods_to_access_matching_districts
    rs = ResultSet.new(matching_districts: [entry1], statewide_average: entry2)
    assert_equal 0.5, rs.matching_districts.first.free_or_reduced_price_lunch_rate
    assert_equal 0.2, rs.statewide_average.children_in_poverty_rate
  end

  def test_headcount_analyst_creates_result_set_with_comparison_methods
    ha = headcount_analyst_all_types
    result_set = ha.high_poverty_and_high_school_graduation
    assert result_set.instance_of? ResultSet
  end

  def test_headcount_analyst_creates_result_set_for_poverty_and_high_school_graduation
    ha = headcount_analyst_all_types
    result_set = ha.high_poverty_and_high_school_graduation
    assert_equal 57, result_set.matching_districts.count
    assert result_set.matching_districts.first.instance_of? ResultEntry
    all = result_set.matching_districts
    state = result_set.statewide_average
    all.each do | district |
      assert district.high_school_graduation_rate > state.high_school_graduation_rate
      assert district.children_in_poverty_rate > state.children_in_poverty_rate
      assert district.free_or_reduced_price_lunch_rate > state.free_or_reduced_price_lunch_rate
    end
  end

  def test_headcount_analyst_compares_median_income_and_poverty_to_create_disparity_result_set
    ha = headcount_analyst_all_types
    result_set = ha.high_income_disparity
    assert_equal 2, result_set.matching_districts.count
    all = result_set.matching_districts
    state = result_set.statewide_average
    all.each do | district |
      assert district.median_household_income > state.median_household_income
      assert district.children_in_poverty_rate > state.children_in_poverty_rate
    end
  end

  def entry1
    ResultEntry.new({free_or_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
  end

  def entry2
    ResultEntry.new({free_or_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})
  end

  def headcount_analyst_all_types
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :high_school_graduation => "./data/High school graduation rates.csv"},
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    ha = HeadcountAnalyst.new(dr)
  end
end
