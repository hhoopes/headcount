require_relative 'unknown_data_error'
class EconomicProfile
  attr_reader :name, :data

  def initialize(data= {})
    @name = data.values.last.upcase
    @data = data
  end

  def median_household_income_in_year(year)
    found = check_key(year, :median_household_income)
    if found.length == 1
      data.fetch(:median_household_income).fetch(found)
    elsif found.length > 1
      first_range = data.fetch(:median_household_income).fetch(found)
      second_range = data.fetch(:median_household_income).fetch(found)
      (first_range + second_range)/2
    else
      raise UnknownDataError
    end
  end

  def check_key(year, parameter)
    # binding.pry
    a = data.fetch(parameter)
    k = a.keys
    # binding.pry
    k.find do |yr|
      year >= yr.first && year <= yr.last
      binding.pry
    end
  #  binding.pry
    #replace the range with just the year
  end


end


# |-- Economic Profile: Gives access to economic information within the district, including:
# |  | -- Median household income
# |  | -- Rates of school-aged children living below the poverty line
# |  | -- Rates of students qualifying for free or reduced price programs
# |  | -- Rates of students qualifying for Title I assistance
