require 'pry'
require_relative 'unknown_data_error'
require_relative 'unknown_race_error'

class StatewideTest
  attr_reader :name, :data, :statewide_test

  def initialize(data = {})
    @data = data
    @name = data[:name].upcase
  end

  def statewide_test
    data.fetch(:statewide_testing) if data.has_key?(:statewide_testing)
  end

  def proficient_by_grade(grade)
    if data.has_key?(grade)
     data.fetch(grade)
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)
    if data.has_key?(race)
      data.fetch(race)
    else
      raise UnknownRaceError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if self.data.fetch(grade).fetch(year).fetch(subject)
      data = data.fetch(grade).fetch(year).fetch(subject)
    end
    if data.class == Fixnum
      truncate_float(data.fetch(grade).fetch(year).fetch(subject))
      data
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if data.fetch(race).fetch(year).fetch(subject)
      truncate_float(data.fetch(race).fetch(year).fetch(subject))
    else
      raise UnknownDataError
    end
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end


end
