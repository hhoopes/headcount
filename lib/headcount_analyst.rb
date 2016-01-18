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

  def calculate_average_rate(d_object)
    if d_object.enrollment.kindergarten_participation
      data = d_object.enrollment.kindergarten_participation.values
      data.inject(0) do |memo, datum|
        memo + datum
      end/data.size
    end
  end

  def kindergarten_participation_rate_variation_trend(d_name1, against_district)
    d_name2 = against_district.fetch(:against)
    d_object1 = get_district(d_name1)
    d_object2 = get_district(d_name2)
    average1 = calculate_average_rate_for_all_years(d_object1, d_object2)
  end

  def calculate_average_rate_for_all_years(d_object1, d_object2)
   if d_object1.enrollment.kindergarten && d_object2.enrollment.kindergarten
     data_hash1 = d_object1.enrollment.kindergarten
     data_hash2 = d_object2.enrollment.kindergarten
       index = 0
       annual_enrollment_hash = {}
       while index < 1 && data_hash1.keys[0] == data_hash2.keys[0] && data_hash1.keys[0] != nil do
         annual_enrollment_hash = data_hash1.merge(data_hash2){|key, first, second| truncate_float(first/second) }
        index += 1
      end
   end
         annual_enrollment_hash
  end

  def get_district(d_name)
    district_repository.find_by_name(d_name)
  end

  def truncate_float(number)
    sprintf("%.3f", number).to_f
  end

end
