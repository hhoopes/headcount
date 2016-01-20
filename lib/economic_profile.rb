class EconomicProfile
  attr_reader :name

  def initialize(economic_profile = {})
    @name = (economic_profile[:name]).upcase
  end

  def median_household_income_in_year


  end


end


# |-- Economic Profile: Gives access to economic information within the district, including:
# |  | -- Median household income
# |  | -- Rates of school-aged children living below the poverty line
# |  | -- Rates of students qualifying for free or reduced price programs
# |  | -- Rates of students qualifying for Title I assistance
