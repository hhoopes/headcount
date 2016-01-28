require 'minitest'
require './lib/headcount_analyst'
require './lib/result_entry'
require './lib/district_repository'
require 'pry'

class ResultEntryTest < Minitest::Test

  def test_create_result_entry_with_data_solely
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
      children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75})

    assert r1.instance_of? ResultEntry
  end

  def test_analyst_creates_a_result_entry_for_each_district
    analyst = headcount_analyst_hs_and_poverty
    districts = analyst.create_district_result_entries([:high_school_graduation_rate])
    assert districts.first.instance_of? ResultEntry
    assert_equal 0.898, districts.first.high_school_graduation_rate
  end

  def headcount_analyst_hs_and_poverty
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/subsets/kindergarten_enrollment.csv",
        :high_school_graduation => "./data/subsets/high_school_enrollment.csv"},
      :economic_profile => {
        :children_in_poverty => "./data/subsets/children_in_pov.csv",
        :free_or_reduced_price_lunch => "./data/subsets/free_or_red_price_lunch.csv",
        }})
    ha = HeadcountAnalyst.new(dr)
  end
end
