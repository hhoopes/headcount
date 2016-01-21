require 'minitest'
require './lib/economic_profile'
require './lib/economic_profile_repository'
require 'pry'

class EconomicProfileTest < Minitest::Test

  def test_economic_profile_creates_instance_of_economic_profile
      data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"
         }
          ep = EconomicProfile.new(data)
    ep.instance_of?(EconomicProfile)
  end

  def test_instance_of_eco_profile_contains_data_for_single_data
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
        economic_profile = EconomicProfile.new(data)
        assert economic_profile.instance_of?(EconomicProfile)
  end

  def test_median_household_income_given_in_method
      data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"
         }
    economic_profile = EconomicProfile.new(data)

    assert_equal 50000, economic_profile.median_household_income_in_year(2005)

    assert_equal 55000, economic_profile.median_household_income_in_year(2009)
  end

  # def test_median_household_income_given_in_method_with_file
  #     dr = DistrictRepository.new
  #     data = dr.load_data({:median_household_income => {"./data/subsets/median_household.csv"},
  #         :children_in_poverty => {"./data/subsets/children_in_pov.csv"}, :free_or_reduced_price_lunch => {"./data/subsets/free_or_red_price_lunch.csv"}, :title_i => {"./data/subsets/title_i_small.csv"}, :name => "ACADEMY 20"
  #     })
  #
  #   economic_profile = EconomicProfile.new(data)
  #
  #   assert_equal 50000, economic_profile.median_household_income_in_year(2005)
  #
  #   assert_equal 55000, economic_profile.median_household_income_in_year(2009)
  # end

  def test_median_household_income_gives_error_if_year_does_not_exist
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"
         }
    economic_profile = EconomicProfile.new(data)

    assert_raises UnknownDataError do  economic_profile.median_household_income_in_year(1880)
    end
  end

  def test_median_household_income_average_gives_correct_range
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 55000, economic_profile.median_household_income_average
  end

  def test_children_in_poverty_gives_percent_for_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
          :children_in_poverty => {2012 => 0.1845},
          :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
          :title_i => {2015 => 0.543},
          :name => "ACADEMY 20"
         }
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.184, economic_profile.children_in_poverty_in_year(2012)
  end

  def test_children_in_poverty_gives_error_if_wrong_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_raises UnknownDataError do  economic_profile.children_in_poverty_in_year(2212)
    end
  end

  def test_free_or_reduced_lunch_gives_correct_percent
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
     }
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.023, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_free_or_reduced_lunch_gives_error_with_wrong_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_raises UnknownDataError do  economic_profile.free_or_reduced_price_lunch_percentage_in_year(1914) end
  end

  def test_free_or_reduced_lunch_gives_number
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 100, economic_profile.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_free_or_reduced_lunch_number_gives_error_for_wrong_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_raises UnknownDataError do  economic_profile.free_or_reduced_price_lunch_number_in_year(2212)
    end
  end

  def test_title_i_gives_correct_percent
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.543, economic_profile.title_i_in_year(2015)
  end

  def test_title_i_gives_error_for_wrong_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_raises UnknownDataError do  economic_profile.title_i_in_year(1115)
    end
  end


end
