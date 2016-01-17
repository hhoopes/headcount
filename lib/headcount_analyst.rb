require_relative 'district_repository'


class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(d_name1, against_district)
    d_name2 = against_district.fetch(:against)
    d_object1 = get_district(d_name1)
    d_object2 = get_district(d_name2)
    average1 = calculate_average_rate(d_object1)
    average2 = calculate_average_rate(d_object2)
    truncate_float(average1/average2)
    #finds the variance between two districts
    #Example: ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1') # => 1.234
  end

  def kindergarten_participation_rate_variation_trend
    #iterates through the years and puts this in a hash
    #Example: ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO') # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }
  end

  def get_district(d_name)
    district_repository.find_by_name(d_name)
  end

  def calculate_average_rate(district)
    data = district.enrollment.kindergarten_participation.values
    data.inject(0) do |memo, datum|
      memo + datum
    end/data.size
  end

  def truncate_float(number)
    sprintf("%.3f", number).to_f
  end

end
