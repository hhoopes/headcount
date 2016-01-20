require 'minitest'
# require './test/test_helper'
require './lib/economic_profile'
require 'pry'

class EconomicProfileTest < Minitest::Test

  # def test_instance_of_eco_profile_contains_data_for_single_data
  #   # skip
  #   data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
  #       :children_in_poverty => {2012 => 0.1845},
  #       :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
  #       :title_i => {2015 => 0.543},
  #       :name => "ACADEMY 20"
  #      }
  #       economic_profile = EconomicProfile.new(data)
  #       assert economic_profile.instance_of?(EconomicProfile)
  # end
 meta t: true
  def test_median_household_income_given_in_method
      data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"
         }
    economic_profile = EconomicProfile.new(data)

    # assert_equal 50000, economic_profile.median_household_income_in_year(2005)

    assert_equal 55000, economic_profile.median_household_income_in_year(2009)
  end

  def test_median_household_income_gives_error_if_year_does_not_exist
    economic_profile = EconomicProfile.new(data)

    assert_equal UnknownDataError, economic_profile.median_household_income_in_year(1880)
  end

  def test_median_household_income_average_gives_correct_range
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal 55000, economic_profile.median_household_income_average
  end

  def test_children_in_poverty_gives_percent_for_year
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.184, economic_profile.children_in_poverty_in_year(2012)
  end

  def test_children_in_poverty_gives_error_if_wrong_year
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal UnknownDataError, economic_profile.children_in_poverty_in_year(2212)
  end

  def test_free_or_reduced_lunch_gives_correct_percent
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.023, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_free_or_reduced_lunch_gives_error_with_wrong_year
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal UnknownDataError, economic_profile.free_or_reduced_price_lunch_percentage_in_year(1914)
  end

  def test_free_or_reduced_lunch_gives_number
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal 100, economic_profile.free_or_reduced_price_lunch_number_in_year(2012)
  end

  def test_free_or_reduced_lunch_number_gives_error_for_wrong_year
    economic_profile = EconomicProfile.new(data)

    assert_equal UnknownDataError, economic_profile.free_or_reduced_price_lunch_number_in_year(2212)
  end

  def test_title_i_gives_correct_percent
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.543, economic_profile.title_i_in_year(2015)
  end

  def test_title_i_gives_error_for_wrong_year
    skip
    economic_profile = EconomicProfile.new(data)

    assert_equal UnknownDataError, economic_profile.title_i_in_year(1115)
  end



end
