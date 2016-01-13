require 'csv'

class Enrollment
  attr_reader :enrollment, :name

  def initialize(enrollment)
    @name = (enrollment[:name]).upcase
    @kindergarten_participation = enrollment[:kindergarten_participation]
  end

  def kindergarten_participation(kindergarten_data)
      kindergarten_data.each do |row|

    end
  end

  def kindergarten_participation_by_year
  #This method returns a hash with years as keys and a truncated three-digit floating point number representing a percentage for all years present in the dataset.

  #Example:
# enrollment.kindergarten_participation_by_year
# => { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267, }

    end

  def truncate_float(number)
    number.to_s.[0..4].to_f
  end

  def kindergarten_participation_in_year(year)
      #A call to this method with any unknown year should return nil.
      # The method returns a truncated three-digit floating point number representing a percentage.
      # Example:
      # enrollment.kindergarten_participation_in_year(2010) # => 0.391

  end

end

#   Enrollment: Gives access to enrollment data within that district, including:
# |  | -- Dropout rate information
# |  | -- Kindergarten enrollment rates
# |  | -- Online enrollment rates
# |  | -- Overall enrollment rates
# |  | -- Enrollment rates by race and ethnicity
# |  | -- High school graduation rates by race and ethnicity
# |  | -- Special education enrollment rates



# ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
#dividing first by colorado number
