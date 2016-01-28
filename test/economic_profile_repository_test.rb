require 'minitest'
require './lib/economic_profile_repository'
require './lib/district_repository'
require './lib/economic_profile'
require 'pry'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_economic_profile_repo_instantiates_
    epr = EconomicProfileRepository.new
    assert epr.instance_of?(EconomicProfileRepository)
  end

  def test_economic_repo_gives_access_to_specific_school_profiles
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
     assert epr.find_by_name("ACADEMY 20").instance_of? EconomicProfile
  end

  def test_instances_held_in_repo_can_access_data
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
     profile = epr.find_by_name("ACADEMY 20")
     assert profile.respond_to? :median_household_income
     assert profile.respond_to? :median_household_income_average
  end
end
