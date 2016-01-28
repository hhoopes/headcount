require 'pry'
require 'data_formatter'
require 'district_repository'
require 'enrollment_repository'

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
    e = EnrollmentRepository.new
    assert e.initial_enrollments_array.empty?
    e.load_data({:enrollment => {:kindergarten_participation => "./data/subsets/bad_data.csv"}})
    assert e.initial_enrollments_array.empty?
  end
end
