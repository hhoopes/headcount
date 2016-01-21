require 'minitest'
# require './test/test_helper'
require './lib/statewide_test_repository'
require 'pry'

class StatewideTestRepositoryTest < Minitest::Test
  def statewide_test_repository_is_initialized
    str = StatewideTestRepository.new
    assert str.instance_of?(StatewideTestRepository)
  end

  def test_statewide_test_repository_takes_input_of_one_category
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv"}})
    t_object = str.find_by_name("Colorado")
    assert_equal StatewideTest, t_object.class
    assert t_object.data.fetch(:third_grade)
  end

  def test_statewide_test_repository_takes_input_of_multiple_categories_and_does_stuff_with_it
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/subsets/third_grade_proficient.csv",
        :eighth_grade => "./data/subsets/eighth_grade_proficient.csv"}})
    t_object = str.find_by_name("Academy 20")
    assert t_object.data.fetch(:third_grade)
    assert t_object.data.fetch(:eighth_grade)
  end

  def test_ethnicity_data_formats_and_fetches_correctly
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :math        => "./data/subsets/math_by_race.csv"}})
    t_object = str.find_by_name("CANON CITY RE-1")
    assert_equal StatewideTest, t_object.class
    assert t_object.data.fetch(:asian)
    assert_equal 3, str.initial_testing_array.length
  end
<<<<<<< HEAD
=======

>>>>>>> headcount_analyst_cleanup
end
