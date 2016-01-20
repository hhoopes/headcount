class StatewideTest
  attr_reader :name, :data
  
  def initialize(data = {})
    @name = data[:name].upcase
    @data = data
  end

#key is #statewide_testing, method is statewide_test
  def statewide_test
    data.fetch(:statewide_testing) if data.has_key?(:statewide_testing)
  end

  def convert_grade_to_symbol
    {3 => :third_grade, 8 => :eighth_grade}
  end
end

# |-- Statewide Testing: Gives access to testing data within the district, including:
# |  | -- 3rd grade standardized test results
# |  | -- 8th grade standardized test results
# |  | -- Subject-specific test results by race and ethnicity
# |  | -- Higher education remediation rates
