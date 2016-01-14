class HeadcountAnalyst

  def initialize(district_repository)

  end

  def kindergarten_participation_rate_variation(district1, against_district)
    district2 = against_district.fetch(:against)
    calculate_average(district1, district2)
    #finds the variance between two districts
    #Example: ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1') # => 1.234
  end

  def kindergarten_participation_rate_variation_trend
    #iterates through the years and puts this in a hash
    #Example: ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO') # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }
  end


end
