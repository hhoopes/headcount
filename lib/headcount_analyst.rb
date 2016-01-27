require 'pry'
require_relative 'headcount_analyst'
require_relative 'custom_errors'

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
    calculate_average_rate_for_all_years(d_object1, d_object2)
  end

  def calculate_average_rate_for_all_years(d_object1, d_object2)
    if d_object1.enrollment.kindergarten_participation && d_object2.enrollment.kindergarten_participation
      data_hash1 = d_object1.enrollment.kindergarten_participation
      data_hash2 = d_object2.enrollment.kindergarten_participation
      map = data_hash1.map do | key, value |
        if data_hash2.has_key?(key)
          new_value = value/data_hash2.fetch(key)
          [key, truncate_float(new_value)]
        end
      end.to_h
    end
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
        if !variation.nil? && 0.6 < variation && variation < 1.5
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

  def top_statewide_test_year_over_year_growth(options)
    raise_errors(options)
    grade = options.fetch(:grade)
    subject = options.fetch(:subject) if options.has_key?(:subject)
    top = (options.fetch(:top) if options.has_key?(:top)) || top = 1
    weighting = (options.fetch(:weighting) if options.has_key?(:weighting))
    if top && subject
     single_subject(grade, subject, top)
    elsif top
      mult_subject(grade, weighting, top)
    end
  end

  def raise_errors(options)
    if options.has_key?(:grade)
      grade = options.fetch(:grade)
    else
      raise InsufficientInformationError, "A grade must be provided to answer this question"
    end
    if grade != 8 && grade != 3
      raise UnknownDataError, "#{grade} is not a known grade"
    end
    if options.has_key?(:weighting) && (options.fetch(:weighting).fetch(:reading) + options.fetch(:weighting).fetch(:writing) + options.fetch(:weighting).fetch(:math) != 1)
      raise IncorrectDataError, "Please make sure weights add up to 1"
    end
  end

  def single_subject(grade, subject, top)
    highest = test_array.map do |district|
      next unless district.data.has_key?(grade)
      scores = district.data.fetch(grade)
      first = verify_year_single(scores, subject).first
      last = verify_year_single(scores, subject).last
      next if first.nil? || last.nil?
      [district.name, truncate_float(calculate_years_growth(first, last, subject: subject))]
    end.reject{|district|district.nil? || district.last.nil?}.sort_by {|district| district.last}
    if top == 1
      highest.last
    else
       top = highest[-top..-1]
    end
  end

  def verify_year_single(hash, subject)
    hash.select do | year, scores |
      scores.has_key?(subject) && (scores.fetch(subject).is_a?(Numeric))
    end.sort_by{| year, score | year}
  end

  def calculate_years_growth(first, last, options = {})
    if !options.nil? && options.has_key?(:subject)
      subjects = [options.fetch(:subject)]
    else
      subjects = [:math, :reading, :writing]
    end
    if !options.nil? && options.has_key?(:weighting) && !options.fetch(:weighting).nil?
      weighting = options.fetch(:weighting)
    else
      weighting = {math:1/3.0, reading: 1/3.0, writing: 1/3.0}
    end
    subjects.inject(0) do |memo, subject|
      memo + ((last.last.fetch(subject) - first.last.fetch(subject))/(last.first - first.first))* weighting.fetch(subject)
    end


  end

  def mult_subject(grade, weighting, top)
    highest =
    test_array.map do |district|
      next unless district.data.has_key?(grade)
      scores = district.data.fetch(grade)
      first = verify_year_mult(scores).first
      last = verify_year_mult(scores).last
      next if first.nil? || last.nil?
      [district.name, truncate_float(calculate_years_growth(first, last, :weighting=> weighting))]
    end.reject{|district|district.nil? || district.last.nil?}.sort_by {|district| district.last}

    if top == 1
      highest.last
    else
       top = highest[-top..-1]
    end
    binding.pry
  end

  def verify_year_mult(hash)
    hash.select do | year, scores |
      scores.has_key?(:math) && scores.has_key?(:writing) && scores.has_key?(:reading) && (scores.fetch(:math).is_a?(Numeric)) && (scores.fetch(:writing).is_a?(Numeric)) && (scores.fetch(:reading).is_a?(Numeric))
    end.sort_by{|year| year}
  end

      #iterate over data looking for detect when path is valid and value is a float


      #find a single leader
  #output: ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
# if not subject, look for growth for all three subjects
#you can weight subjects too: ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})

      #find multiple leaders


    # Where 0.123 is their average percentage growth across years. If there are three years of proficiency data (year1, year2, year3), that's ((proficiency at year3) - (proficiency at year1)) / (year3 - year1).

# => ['the top district name', 0.123]

# => ['the top district name', 0.111]
#weights must add up to one

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
    if (number.is_a? Numeric) && !number.nan?
      (number * 1000).floor/1000.0
    end
  end

  def path_valid?(key1, key2, key3 = nil)
    if (data.has_key?(key1) &&
      data.fetch(key1).has_key?(key2) && !key3.nil?) ||
      (data.has_key?(key1) &&
      data.fetch(key1).has_key?(key2) &&
      data.fetch(key1).fetch(key2).has_key?(key3))
      true
    else false
    end
  end

end
