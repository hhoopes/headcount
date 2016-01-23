require 'pry'
require_relative 'headcount_analyst'
require_relative 'unknown_data_error'
require_relative 'insufficient_information_error'

class HeadcountAnalyst
  attr_reader :district_repository, :test_array

  def initialize(district_repository)
    @district_repository = district_repository
    @test_array = district_repository.testing_repo.initial_testing_array
  end

  def kindergarten_participation_rate_variation(d_name1, d_name2)
    d_2 = d_name2.fetch(:against)
    calculate_variation(d_name1, :kindergarten_participation, d_2)
  end

  def calculate_variation(d_name1, data_type, d_name2 = 'Colorado')
    d_object1 = get_district(d_name1)
    d_object2 = get_district(d_name2)
    average1 = calculate_average_rate(d_object1, data_type)
    average2 = calculate_average_rate(d_object2, data_type)
    truncate_float(average1/average2)
  end

  def calculate_average_rate(d_object, data_type)
    if d_object.enrollment.data.fetch(data_type)
      data = d_object.enrollment.data.fetch(data_type).values
      data.inject(0) do |memo, datum|
        memo + datum
      end/data.size
    end
  end

  def kindergarten_participation_rate_variation_trend(d_name1, other_name)
    d_name2 = other_name.fetch(:against)
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
       while (index < 1) && (data_hash1.keys[0] == data_hash2.keys[0]) && (data_hash1.keys[0] != nil) do
         annual_enrollment_hash =
         data_hash1.merge(data_hash2){|key, first, second| truncate_float(first/second) }
        index += 1
      end
   end
    annual_enrollment_hash
  end

  def kindergarten_participation_against_high_school_graduation(d_name)
    kindergarten_variation  = calculate_variation(d_name, :kindergarten_participation)
    graduation_variation    = calculate_variation(d_name, :high_school_graduation)
    kindergaten_graduation_variance = kindergarten_variation/ graduation_variation
    truncate_float(kindergaten_graduation_variance)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(d_hash)
    correlation = false
    if d_hash.keys.include?(:for)
      d_name = d_hash[:for]
      if d_name.upcase == "STATEWIDE"
        results = group_correlation(district_repository.initial_districts_array.map {|district| district.name})
        correlation = true if results > 0.7
      else #one school
        variation = kindergarten_participation_against_high_school_graduation(d_name)
        if 0.6 < variation && variation < 1.5
           correlation = true
         end
       end
    else
      d_array = d_hash.fetch(:across)
      results = group_correlation(d_array)
      correlation = true if results > 0.7
    end
    correlation
  end

  def group_correlation(name_array)
    district_num =
    name_array.group_by do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for => district)
    end
     district_num.values.first.count/name_array.count
  end

  def top_statewide_test_year_over_year_growth(grade = nil, subject)
      binding.pry
    grade = grade.fetch(:grade)
    if grade == nil
      raise InsufficientInformationError, "A grade must be provided to answer this question"
    elsif grade == 9
      raise UnknownDataError, "9 is not a known grade"
    end
  end

  def top_statewide_test_year_over_year_growth(grade, subject)
    # Where 0.123 is their average percentage growth across years. If there are three years of proficiency data (year1, year2, year3), that's ((proficiency at year3) - (proficiency at year1)) / (year3 - year1).
    #output: ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
# => ['the top district name', 0.123]
   # if not subject, look for growth for all three subjects
   #you can weight subjects too: ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
# => ['the top district name', 0.111]
#weights must add up to one
  end

  # def top_statewide_test_year_over_year_growth(opts = {})
  #   grade     = opts.fetch(:grade) if opts.has_key?(:grade)
  #   subject   = opts.fetch(:subject) if opts.has_key?(:subject)
  #   top       = opts.fetch(:top) if opts.has_key?(:top)
  #   weighting = opts.fetch(:weighting) if opts.has_key?(:weighting)
  #   binding.pry
  #   # raise_errors(opts)
  #   if grade && weighting
  #     calculate_weighting(grade: grade, weighting: weighting)
  #   elsif grade && subject && top
  #     calculate_multiple_leaders(grade: grade, subject: subject, top: top)
  #   elsif grade && subject
  #     calculate_single_leader(grade: grade, subject: subject)
  #   else grade
  #     calculate_whole_grade(grade: grade)
  #   end
  # end

  def get_district(d_name)
    district_repository.find_by_name(d_name)
  end

  def truncate_float(number)
    (number * 1000).truncate/(1000.to_f)
  end

end
