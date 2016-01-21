require 'pry'
require_relative 'unknown_data_error'

class EconomicProfile
  attr_reader :name, :data

  def initialize(data= {})
    @data = data
    @name = data[:name].upcase
  end

  def median_household_income
    data.fetch(:median_household_income)
  end

  def median_household_income_in_year(year)
    found = check_key_with_range(year, :median_household_income)
    if found.length > 0
      found.inject(0) do |sum, range|
        sum + median_household_income.fetch(range)
      end/found.length
    else
      raise UnknownDataError
    end
  end

  def median_household_income_average
    all_incomes = (data.fetch(:median_household_income).values)
    all_incomes.inject(:+)/all_incomes.length
  end

  def children_in_poverty_in_year(year)
    if check_key(year, :children_in_poverty)
      truncate_float(data.fetch(:children_in_poverty)[year])
    else
      raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if check_key(year, :free_or_reduced_price_lunch)
      data.fetch(:free_or_reduced_price_lunch)[year][:percentage]
    else
      raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
     if check_key(year, :free_or_reduced_price_lunch)
       data.fetch(:free_or_reduced_price_lunch)[year][:total]
     else
       raise UnknownDataError
     end
  end

  def title_i_in_year(year)
    if check_key(year, :title_i)
      data.fetch(:title_i)[year]
    else
      raise UnknownDataError
    end
  end

  def check_key(year, parameter)
    year_data = data.fetch(parameter).keys
    year_data.include?(year)
  end

  def check_key_with_range(year, parameter)
    year_data = data.fetch(parameter).keys
      year_data.find_all do |yr|
        year >= yr.first && year <= yr.last
      end
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end

end
