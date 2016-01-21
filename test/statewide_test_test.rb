require 'minitest'
# require './test/test_helper'
require './lib/statewide_test'
require 'pry'

class StatewideTestTest < Minitest::Test

meta s: true
  def test_statewide_test_instantiates
    str = StatewideTest.new({:name => "test"})
    assert str.instance_of?(StatewideTest)
  end
meta s1: true
  def test_proficient_by_grade_returns_data_from_grade

    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
             2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
             2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
             2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
             2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
             2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
             2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
           }

    statewide_test = StatewideTest.new(:name => "Colorado", :third_grade => expected)

    actual = statewide_test.proficient_by_grade(3)
    assert_equal expected, actual
    # actual.values.zip(expected.values).each do |pair|
    # assert_in_delta pair.last, pair.first, 0.005
  end
meta s2: true
  def test_proficient_by_grade_returns_error_if_wrong_year
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
             2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
             2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
             2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
             2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
             2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
             2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
           }
    statewide_test = StatewideTest.new(:name => "Colorado", :third_grade => expected)

    assert_raises UnknownDataError do
       statewide_test.proficient_by_grade(4)
     end
  end
meta twang:true
  def test_proficient_by_race_or_ethnicity_gives_percent_proficiency_for_given_race
    skip
     expected =  { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
       2012 => {math: 0.818, reading: 0.893, writing: 0.808},
       2013 => {math: 0.805, reading: 0.901, writing: 0.810},
       2014 => {math: 0.800, reading: 0.855, writing: 0.789},
       }

      statewide_test = StatewideTest.new(expected)

      actual = statewide_test.proficient_by_race_or_ethnicity(:asian)

    #  actual.values.zip(expected.values).each do |pair|
    #  assert_in_delta pair.last, pair.first, 0.005
    assert_equal expected, actual
  end
  #write test to pass in file
meta s4: true
  def test_proficient_by_race_returns_error_if_unknown_race
    skip
   expected =  { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789},
     }

    statewide_test = StatewideTest.new(expected)
    actual = statewide_test.proficient_by_race_or_ethnicity(:skaterboys)

    assert_raises UnknownRaceError do
       actual
     end
  end
meta s5: true
  def test_proficient_for_subject_by_grade_in_year_gives_correct_percent
   skip
   expected =  { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789},
     }

    statewide_test = StatewideTest.new(expected)

     assert_equal 0.857, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end
meta s6: true
  def test_proficient_for_subject_by_grade_in_year_gives_correct_percent
    skip
   expected =  { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789},
     }

    statewide_test = StatewideTest.new(expected)
    
    assert_raises UnknownDataError do  statewide_test.proficient_for_subject_by_grade_in_year(:science, 3, 2008)
    end
  end
meta s7: true
  def test_proficient_for_subject_by_race_returns_correct_percent
    skip
    statewide_test = StatewideTest.new(:name => "Colorado", :third_grade => expected)

    assert_equal 0.818, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end
meta s8: true
  def test_proficient_for_subject_by_race_returns_error_if_wrong_parameter
    skip
    statewide_test = StatewideTest.new(:name => "Colorado", :third_grade => expected)

    assert_raises UnknownDataError do  statewide_test.proficient_for_subject_by_race_in_year(:history, :asian, 2012)
    end
  end
meta s9: true
  def test_proficient_for_subject_by_race_returns_error_if_multiple_wrong_parameters
    skip
    statewide_test = StatewideTest.new(:name => "Colorado", :third_grade => expected)

    assert_raises UnknownDataError do  statewide_test.proficient_for_subject_by_race_in_year(:history, :cyborg, 2012)
    end
  end
meta s10: true
  def test_proficient_for_subject_by_race_returns_error_if_all_wrong_parameters
    skip
    statewide_test = StatewideTest.new(:name => "Colorado", :third_grade => expected)

    assert_raises UnknownDataError do  statewide_test.proficient_for_subject_by_race_in_year(:history, :cyborg, 200)
    end
  end

end
