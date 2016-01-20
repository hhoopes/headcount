require 'pry'
require 'unknown_data_error'

class StatewideTest
  attr_reader :name, :data

  def initialize(data = {})
    @data = data
    @name = data[:name].upcase
  end

#key is #statewide_testing, method is statewide_test
  def statewide_test
    data.fetch(:statewide_testing) if data.has_key?(:statewide_testing)
  end

  def proficient_by_grade(grade)
    # binding.pry
    if data.has_key?(convert_grade_to_symbol[grade])
     data.fetch(convert_grade_to_symbol[grade])
   else
      "UnknownDataError"
   end
  end

  def convert_grade_to_symbol
    {3 => :third_grade, 8 => :eighth_grade}
  end

  def proficient_by_race_or_ethnicity(race)
    if data.has_key?([race])
     data.fetch([race])
    else
       "UnknownRaceError"
    end
  end

end

# |-- Statewide Testing: Gives access to testing data within the district, including:
# |  | -- 3rd grade standardized test results
# |  | -- 8th grade standardized test results
# |  | -- Subject-specific test results by race and ethnicity
# |  | -- Higher education remediation rates
