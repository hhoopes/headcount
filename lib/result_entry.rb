class ResultEntry
  attr_reader :values
  def initialize(values = {})
    @values = values
  end

  def free_or_reduced_price_lunch_rate
    values.fetch(:free_or_reduced_price_lunch_rate) if values.has_key? :free_or_reduced_price_lunch_rate
  end

  def children_in_poverty_rate
    values.fetch(:children_in_poverty_rate) if values.has_key? :children_in_poverty_rate
  end

  def high_school_graduation_rate
    values.fetch(:high_school_graduation_rate) if values.has_key? :high_school_graduation_rate
  end

  def median_household_income
    values.fetch(:median_household_income) if values.has_key? :median_household_income
  end

  def name
    values.fetch(:name)
  end


end
