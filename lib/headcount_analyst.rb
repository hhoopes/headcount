require 'district_repository'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district1, against_district)
    district2 = against_district.fetch(:against)
    fetched1 = fetch_district(district1)
    fetched2 = fetch_district(district2)
    average1 = calculate_average_rate(fetched1)
    average2 = calculate average_rate(fetched2)
    average1/average2
    #finds the variance between two districts
    #Example: ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1') # => 1.234
  end

  def kindergarten_participation_rate_variation_trend
    #iterates through the years and puts this in a hash
    #Example: ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO') # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }
  end

  def fetch_district(district)
    district_repository.find_by_name(district)
  end

  def calculate_average_rate(district)
    district.enrollment.values.collect do |memo, enrollment_data|
      memo + enrollment_data
    end/district.enrollment.values.length
  end


end
