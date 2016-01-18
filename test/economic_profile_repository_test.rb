require 'minitest'
# require './test/test_helper'
require './lib/economic_profile_repository'
require './lib/district_repository'
require 'pry'

class EconomicProfileRepositoryTest < Minitest::Test
#iteration 4
  def test_economic_profile_repo_instantiates_
    epr = EconomicProfileRepository.new
    assert epr.instance_of?(EconomicProfileRepository)
  end

  def test_economic_information_given_when_run_load_data_for_specific_school
    skip
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

     assert_equal "Economic Profile", epr.find_by_name("ACADEMY 20")
  end

end
