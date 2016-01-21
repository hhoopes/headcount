require 'pry'
require 'data_formatter'
require 'statewide_test_repository'

class DataFormatterTest <Minitest::Test
  def test_data_formatter_creates_an_instance_of_df_when_initialized
    df = DataFormatter.new
    assert df.instance_of?(DataFormatter)
  end

  def test_initialized_data_excludes_unneccessary_data
    # skip
    df = DataFormatter.new
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
   assert_equal "hi", df.data.exclude_data
  end

  def test_format_data_organizes_data_into_mapped_extracted

  end

  def test_map_data_organizes_data_according_to_category

  end
  def test_format_lunch_organizes_dataformat_with_appropriate_titles

  end

  def test_format_ethnicity_appropriately


  end

  def test_format_kindergarten_organizes_data_appropriately


  end

end
