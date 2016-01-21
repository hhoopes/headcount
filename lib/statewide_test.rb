require 'pry'
require_relative 'unknown_data_error'
require_relative 'unknown_race_error'

class StatewideTest
  attr_reader :name, :data

  def initialize(data = {})
    # binding.pry
    @data = data
    @name = data[:name].upcase
  end

  def statewide_test
    data.fetch(:statewide_testing) if data.has_key?(:statewide_testing)
  end

  def proficient_by_grade(grade)
    if data.has_key?(convert_grade_to_symbol[grade])
     data.fetch(convert_grade_to_symbol[grade])
    else
      raise UnknownDataError
    end
  end

  def convert_grade_to_symbol
    {3 => :third_grade, 8 => :eighth_grade}
  end

  def proficient_by_race_or_ethnicity(race)
    if data.fetch(race)
      find_math_proficiency(race)
      # find_reading_proficiency(race)
      # find_writing_proficiency(race)
    else
       raise UnknownRaceError
    end
  end

  def find_math_proficiency(race)
    binding.pry
    all_years_data = data.fetch(race).values
    simple_data = all_years_data.map {|year_data| year_data.values}
    clean_data = simple_data.inject(:+)
    math_proficiency = clean_data.inject(0) do |sum, num|
      sum + num
    end/clean_data.size
    truncate_float(math_proficiency)
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end
end

# |-- Statewide Testing: Gives access to testing data within the district, including:
# |  | -- 3rd grade standardized test results
# |  | -- 8th grade standardized test results
# |  | -- Subject-specific test results by race and ethnicity
# |  | -- Higher education remediation rates
