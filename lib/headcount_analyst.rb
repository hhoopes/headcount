require_relative 'headcount_analyst'

class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(d_name1, against_district)
    d_2 = against_district.fetch(:against)
    calculate_variation(d_name1, d_2, :kindergarten_participation)
  end

  def calculate_average_rate(d_object, data_type)
    if d_object.enrollment.method(data_type).call  #alternative is to look up the enrollment object and fetch the key
      data = d_object.enrollment.data.fetch(data_type).values
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
  
  def kindergarten_participation_against_high_school_graduation(d_name)
    # binding.pry
    kindergarten_variation =  calculate_variation(d_name, :kindergarten_participation)
    graduation_variation =  calculate_variation(d_name, :high_school_graduation)
    kindergaten_graduation_variance = kindergarten_variation/ graduation_variation
  end

  def calculate_variation(d_name1, data_type, d_name2 = 'Colorado')
    d_object1 = get_district(d_name1)
    d_object2 = get_district(d_name2)
    average1 = calculate_average_rate(d_object1, data_type)
    average2 = calculate_average_rate(d_object2, data_type)
    truncate_float(average1/average2)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(d_hash)
    correlation = false
    d_name = d_hash[:for]
      if d_name.upcase == "STATEWIDE"
        results = statewide_correlation
      	if
         	statewide_correlation > 0.7
          correlation = true
     		end
      elsif d_hash.keys.first == :across
          d_array = d_hash.fetch(:across)
            variation_array = d_array.map do |d_name|
              kindergarten_participation_correlates_with_high_school_graduation(d_name)
          end
        else #one school
            variation = kindergarten_participation_against_high_school_graduation(d_name)
            if 0.6 < variation < 1.5
               correlation = true
            end
      end
        correlation
   end

  def statewide_correlation
    district_num = district_repository.initial_districts_array.group_by do |district|
      kindergarten_participation_correlates_with_high_school_graduation(for: district.name) == true
    end
     state_variation = district_num.fetch(true).count/ district_num.fetch(false).count
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end

end
