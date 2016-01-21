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
    if data.include?(race)
      data.fetch(race)
    else
       raise UnknownRaceError
    end
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
