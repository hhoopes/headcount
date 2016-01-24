require 'pry'
require_relative 'custom_errors'

class StatewideTest
  attr_reader :name, :data

  def initialize(data = {})
    @data = data
    @name = data[:name].upcase
  end

  def statewide_test
    data.fetch(:statewide_test) if data.has_key?(:statewide_test)
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

  def path_valid?(key1, key2, key3)
    if data.has_key?(key1) &&
      data.fetch(key1).has_key?(key2) &&
      data.fetch(key1).fetch(key2).has_key?(key3)
      true
    else false
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if path_valid?(grade, year, subject)
      found = data.fetch(grade).fetch(year).fetch(subject)
      if found.class == String
        found
      else found = truncate_float(found)
      end
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if path_valid?(race, year, subject)
      found = data.fetch(race).fetch(year).fetch(subject)
      if found.class == String
        found
      else found = truncate_float(found)
      end
    else
      raise UnknownDataError
    end
  end

  def truncate_float(number)
    (number * 1000).truncate/1000.to_f
  end


end
