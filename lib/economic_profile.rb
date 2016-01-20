require 'pry'
require_relative 'unknown_data_error'
class EconomicProfile
  attr_reader :name, :data

  def initialize(data= {})
    @name = data.values.last.upcase
    @data = data
  end

  def median_household_income
    data.fetch(:median_household_income)
  end

  def median_household_income_in_year(year)
    found = check_key(year, :median_household_income)
    # binding.pry
    if found
      found.inject(0) do |sum, range|
        sum + median_household_income.fetch(range)
      end/found.length
    else
      raise UnknownDataError
    end
  end

  def check_key(year, parameter)
    a = data.fetch(parameter)
    k = a.keys
    k.find_all do |yr|
      year >= yr.first && year <= yr.last
    end
  end

  def median_household_income_average
    all_incomes = (data.fetch(:median_household_income).values)
    all_incomes.inject(:+)/all_incomes.length
  end

  def children_in_poverty_in_year(year)
    data.fetch(:children_in_poverty)
    binding.pry
  end


end


# |-- Economic Profile: Gives access to economic information within the district, including:
# |  | -- Median household income
# |  | -- Rates of school-aged children living below the poverty line
# |  | -- Rates of students qualifying for free or reduced price programs
# |  | -- Rates of students qualifying for Title I assistance
