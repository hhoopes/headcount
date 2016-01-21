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
    if found
      found.inject(0) do |sum, range|
        sum + median_household_income.fetch(range)
      end/found.length
    else
      raise UnknownDataError
    end
  end

  def check_key(year, parameter)
    year_data = data.fetch(parameter).keys
    # binding.pry
    if year_data[0].length > 1
      year_data.find_all do |yr|
        year >= yr.first && year <= yr.last
      end
    else
      if year_data.include?(year)
        true
      end
    end
  end

  def median_household_income_average
    all_incomes = (data.fetch(:median_household_income).values)
    all_incomes.inject(:+)/all_incomes.length
  end

  def children_in_poverty_in_year(year)
    if found = check_key(year, :children_in_poverty)
      truncate_float(data.fetch(:children_in_poverty)[year])
    else
      raise UnknownDataError
    end
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end


end


# |-- Economic Profile: Gives access to economic information within the district, including:
# |  | -- Median household income
# |  | -- Rates of school-aged children living below the poverty line
# |  | -- Rates of students qualifying for free or reduced price programs
# |  | -- Rates of students qualifying for Title I assistance
