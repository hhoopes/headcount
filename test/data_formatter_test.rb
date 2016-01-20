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
    t_object = str.find_by_name("BETHUNE R-5")
    assert_equal StatewideTest, t_object.class
    assert t_object.data.fetch(:third_grade)
  end
end
