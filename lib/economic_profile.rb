class EconomicProfile
  attr_reader :name, :data

  def initialize(data= {})
    @name = (economic_profile[:name]).upcase
    @data - data
  end

  def median_household_income_in_year(year)
    binding.pry
    if data.has_key?(year)
    data.fetch(year[:median_household_income])
    else
      raise UnknownDataError
    end
  end


end


# |-- Economic Profile: Gives access to economic information within the district, including:
# |  | -- Median household income
# |  | -- Rates of school-aged children living below the poverty line
# |  | -- Rates of students qualifying for free or reduced price programs
# |  | -- Rates of students qualifying for Title I assistance
