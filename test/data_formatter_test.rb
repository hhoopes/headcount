require 'pry'
require 'data_formatter'
require 'statewide_test_repositoryB'

class DataFormatterTest <Minitest::Test

  meta data:true
    def test_statewide_test_repository_takes_input_of_one_category
      str = StatewideTestRepositoryB.new
      str.load_data({
        :statewide_testing => {
          :third_grade => "./data/subsets/third_grade_proficient.csv"}})
      t_object = str.find_by_name("CANON CITY RE-1")
      assert_equal StatewideTest, t_object.class
      assert t_object.data.fetch(:third_grade)
  end

  def test_statewide_test_repository_takes_input_of_two_category
    str = StatewideTestRepositoryB.new
    str.load_data({
      :statewide_testing => {
        :third_grade  => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv",
        :math        => "./data/subsets/third_grade_proficient.csv"}})
    t_object = str.find_by_name("CANON CITY RE-1")
    assert_equal StatewideTest, t_object.class
    assert t_object.data.fetch(:third_grade)
    assert t_object.data.fetch(:math)
    assert_equal "", str.initial_testing_array.length
  end
end
