require 'pry'
require 'data_formatter'
require 'statewide_test_repository'

class DataFormatterTest <Minitest::Test
  def test_data_formatter_creates_an_instance_of_df_when_initialized
    df = DataFormatter.new
    assert df.instance_of?(DataFormatter)
  end

  def test_initialized_data_is_sorted
    data = [[:high_school_graduation, "ACADEMY 20", 2005 => 45664]]

      e = EnrollmentRepository.new
      assert e.initial_enrollments_array.empty?
      e.sort_data(data)
      refute e.initial_enrollments_array.empty?
  end

  def test_data_formatter_excludes_bad_data
    skip
    data = [[:high_school_graduation, "ACADEMY 20", 2005 => 'LNE']]

    e = EnrollmentRepository.new
    assert e.initial_enrollments_array.empty?
    e.sort_data(data)
    assert e.initial_enrollments_array.empty?
  end

  def test_format_data_organizes_data_into_mapped_extracted
    skip
    df = DataFormatter.new
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => "LNE"},
        :name => "ACADEMY 20"
       }
    st = StatewideTest.new(data)
    st.load_data(data)
   assert_equal "hi", df.format_data(:median_household_income, './data/subset/median_household.csv')
  end


end
