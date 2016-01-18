class StatewideTest
  def initialize(statewide_test = {})
    @name = statewide_test[:name].upcase
  end
end

# |-- Statewide Testing: Gives access to testing data within the district, including:
# |  | -- 3rd grade standardized test results
# |  | -- 8th grade standardized test results
# |  | -- Subject-specific test results by race and ethnicity
# |  | -- Higher education remediation rates
