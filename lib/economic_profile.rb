require 'pry'
require_relative 'custom_errors'

class EconomicProfile
  attr_reader :name, :data

  def initialize(data= {})
    @data = data
    @name = data[:name].upcase if data.has_key?(:name)
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
    else raise UnknownDataError
    end
  end

  def median_household_income_average
    return if !data.has_key?(:median_household_income)
    all_incomes = (data.fetch(:median_household_income).values)
    all_incomes.inject(0) do |memo, income|
      memo + income
    end./all_incomes.length
  end

  def children_in_poverty_average
    return unless data.has_key? (:children_in_poverty)
    avg =
    data.fetch(:children_in_poverty).values.inject(0) do | memo, datum|
      next if !datum.has_key?(:percentage)
      memo = 0 if memo.nil?
      memo + datum.fetch(:percentage)
    end/data.fetch(:children_in_poverty).values.length
    truncate_float avg
  end

  def children_in_poverty_in_year(year)
    if check_key(year, :children_in_poverty)
      truncate_float(data.fetch(:children_in_poverty)[year])
    else raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_average_percent
    return unless data.has_key?(:free_or_reduced_price_lunch)
    total = 0
    data.fetch(:free_or_reduced_price_lunch).values.each do | datum|
      next if !datum.has_key?(:percentage)
      total += datum.fetch(:percentage)
    end
    truncate_float(total/data.fetch(:free_or_reduced_price_lunch).values.length)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if check_key(year, :free_or_reduced_price_lunch)
      data.fetch(:free_or_reduced_price_lunch)[year][:percentage]
    else raise UnknownDataError
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if check_key(year, :free_or_reduced_price_lunch)
      data.fetch(:free_or_reduced_price_lunch)[year][:total]
    else raise UnknownDataError
    end
  end

  def title_i_in_year(year)
    if check_key(year, :title_i)
      data.fetch(:title_i)[year]
    else raise UnknownDataError
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
    (number * 1000).floor/1000.to_f
  end

end
