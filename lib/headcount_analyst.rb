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
  end

  def calculate_average_rate(d_object, data_type)
    if d_object.enrollment.data.has_key?(data_type)
      data = d_object.enrollment.fetch(data_type.values)
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
   if d_object1.enrollment.kindergarten_participation && d_object2.enrollment.kindergarten_participation
     data_hash1 = d_object1.enrollment.kindergarten_participation
     data_hash2 = d_object2.enrollment.kindergarten_participation
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

  def kindergarten_participation_against_high_school_graduation(district1)
    kindergarten_variation =  calculate_variation(district1, 'Colorado', :kindergarten_participation)
    high_school_variation =  calculate_variation(district1, 'Colorado', :high_school_graduation)
  end

    def calculate_variation(d_object1, d_name2 = 'Colorado', data_type)
        d_object1 = get_district(d_name1)
        d_object2 = get_district(d_name2)
        average1 = calculate_average_rate(d_object1, data_type)
        average2 = calculate_average_rate(d_object2, data_type)
        truncate_float(average1/average2)

    end

  def kindergarten_participation_correlates_with_high_school_graduation(d_hash)
    d_name = d_hash.fetch(:for)
       kindergarten_variation = kindergarten_participation_correlates_with_high_school_graduation(d_name)
       if correlation > 0.6 || correlation < 1.5
         true
       end
     end

  def truncate_float(number)
    sprintf("%.3f", number).to_f
  end

end
