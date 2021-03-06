require 'minitest'
require './lib/statewide_test'
require './lib/statewide_test_repository'
require 'pry'

class StatewideTestTest < Minitest::Test
  def test_statewide_test_instantiates
    st = StatewideTest.new({:name => "test"})
    assert st.instance_of?(StatewideTest)
  end

  def test_proficient_by_grade_returns_data_from_grade
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
             2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
             2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
             2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
             2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
             2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
             2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
           }

    statewide_test = StatewideTest.new(:name => "Colorado", 3 => expected)

    actual = statewide_test.proficient_by_grade(3)
    assert_equal expected, actual
  end

  def test_proficient_by_grade_returns_error_if_wrong_year
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
             2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
             2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
             2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
             2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
             2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
             2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
           }
    statewide_test = StatewideTest.new(:name => "Colorado", 3 => expected)

    assert_raises UnknownDataError do
       statewide_test.proficient_by_grade(4)
     end
  end
end

class StatewideTestRepositoryIntegrationTest < Minitest::Test
  def test_proficient_by_race_or_ethnicity_gives_percent_proficiency_for_given_race
   data = {:statewide_testing => {:math => "./data/subsets/math_by_race.csv", :reading => "./data/subsets/reading_by_race.csv", :writing => "./data/subsets/writing_by_race.csv"}}
   str = StatewideTestRepository.new
   str.load_data(data)
   state = str.find_by_name('Colorado')

      proficiency_hash = {2011=>{:math=>0.7094, :reading=>0.7482, :writing=>0.6569},
       2012=>{:math=>0.7192, :reading=>0.7574, :writing=>0.6588},
       2013=>{:math=>0.7323, :reading=>0.7692, :writing=>0.6821},
       2014=>{:math=>0.7341, :reading=>0.7697, :writing=>0.6846}}
    assert_equal proficiency_hash, state.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_by_race_returns_error_if_unknown_race
     data = {:statewide_testing => {:math => "./data/subsets/math_by_race.csv", :reading => "./data/subsets/reading_by_race.csv", :writing => "./data/subsets/writing_by_race.csv"}}
     str = StatewideTestRepository.new
     str.load_data(data)
     state = str.find_by_name('Colorado')

    assert_raises UnknownRaceError do  state.proficient_by_race_or_ethnicity(:skaterboi)
    end
  end
meta roll: true
  def test_proficient_for_subject_by_grade_in_year_gives_correct_percent
    data = {:statewide_testing => {:third_grade=> "./data/subsets/third_grade_proficient.csv"}}
    str = StatewideTestRepository.new
    str.load_data(data)
    state = str.find_by_name('Colorado')

    assert_equal 0.697, state.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_proficient_for_subject_by_grade_in_year_gives_error_if_wrong_parameters
    data = {:statewide_testing => {:third_grade=> "./data/subsets/third_grade_proficient.csv"}}
    str = StatewideTestRepository.new
    str.load_data(data)
    state = str.find_by_name('Colorado')

    assert_raises UnknownDataError do  state.proficient_for_subject_by_grade_in_year(:history, 3, 2008)
    end
  end

  def test_proficient_for_subject_by_race_returns_correct_percent
    data = {:statewide_testing => {:math => "./data/subsets/math_by_race.csv", :reading => "./data/subsets/reading_by_race.csv", :writing => "./data/subsets/writing_by_race.csv"}}
    str = StatewideTestRepository.new
    str.load_data(data)
    state = str.find_by_name('Colorado')

    assert_equal 0.719, state.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

  def test_proficient_for_subject_by_race_returns_error_if_wrong_parameter
    data = {:statewide_testing => {:math => "./data/subsets/math_by_race.csv", :reading => "./data/subsets/reading_by_race.csv", :writing => "./data/subsets/writing_by_race.csv"}}
    str = StatewideTestRepository.new
    str.load_data(data)
    state = str.find_by_name('Colorado')

    assert_raises UnknownDataError do  state.proficient_for_subject_by_race_in_year(:history, :asian, 2012)
    end
  end

end
