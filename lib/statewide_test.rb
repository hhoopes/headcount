require 'pry'
require_relative 'unknown_data_error'
require_relative 'unknown_race_error'

class StatewideTest
  attr_reader :name, :data

  def initialize(data = {})
    @data = data
    @name = data[:name].upcase
  end

  def statewide_test
    data.fetch(:statewide_testing) if data.has_key?(:statewide_testing)
  end

  def proficient_by_grade(grade)
    if data.has_key?(convert_grade_to_symbol[grade])
     data.fetch(convert_grade_to_symbol[grade])
    else
      raise UnknownDataError
    end
  end

  def convert_grade_to_symbol
    {3 => :third_grade, 8 => :eighth_grade}
  end

  def proficient_by_race_or_ethnicity(race)
    if data.include?(race)
      data.fetch(race)
    else
      raise UnknownRaceError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    grade_sym = convert_grade_to_symbol[grade]
    annual_subject_data = data.fetch(grade_sym)
    years = annual_subject_data.map {|key, value| key}
    subject_data = annual_subject_data.map {|key, value| value}
    if annual_subject_data != nil && subject_data[0].keys.include?(subject.to_s.capitalize) && years.include?(year)
      annual_data = (data.fetch(grade_sym)[year])
      annual_data[subject.to_s.capitalize]
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    year_and_subj = data[(race)]
    years = year_and_subj.map {|key, value| key}
    subj = year_and_subj.map {|key, value| value}
    if year_and_subj != nil && subj[0].keys.include?(subject) && years.include?(year)

      annual_race_data = data.fetch(race)[year][subject]
      truncate_float(annual_race_data)
    else
      raise UnknownDataError
    end
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end


end
