require 'csv'

class Enrollment
  attr_reader :enrollment, :name

    def initialize(enrollment)
      @name = enrollment[:name]
      #initalizes and passes in a hash within a hash that gives parameters, :name => district_name, :specific_data => {year => percent}
      #example: e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
    end

    def name
      enrollment.fetch(:name).upcase
    end

    def kindergarten_participation(kindergarten_data)
      kindergarten_data.each do |row|
        district = row[:location]
        puts district
      end
    end

    def kindergarten_participation_by_year
  #This method returns a hash with years as keys and a truncated three-digit floating point number representing a percentage for all years present in the dataset.

  #Example:
# enrollment.kindergarten_participation_by_year
# => { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267, }

    end

    def truncate_float(number)
      number
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
