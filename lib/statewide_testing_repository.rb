require 'csv'
require_relative './statewide_testing'
require_relative './district_repository'
require 'pry'

class StatewideTestingRepository
  attr_reader :initial_statewide_testing_array

  def initialize
    @initial_statewide_testing_array = []
  end

  def load_data(request_hash)
    #some how pull out request hash data_category_info and run that through the data category method
    key_and_file = get_key_and_file(request_hash)
    load_enrollment(key_and_file)
  end

  def get_key_and_file(hash)
    hash.fetch(data_category(data_category_info))
    #  hash.fetch(:enrollment)
  end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

# str.load_data({
#   :statewide_testing => {
#     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
#     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
#     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
#     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
#     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
#   }
# })
# str = str.find_by_name("ACADEMY 20")
# # => <StatewideTest>
  def data_category(data_category_info)
    if data_category_info.include?("third_grade")
      file = "./data/subsets/third_grade_proficient.csv"
    elsif data_category_info.include?("eighth_grade")
      file = "./data/subsets/eighth_grade_proficient.csv"
    elsif data_category_info.include?("math")
      file = "./data/subsets/math_by_race.csv"
    elsif data_category_info.include?("reading")
      file = "./data/subsets/reading_by_race.csv"
    elsif data_category_info.include?("writing")
      file = "./data/subsets/writing_by_race"
    else
      nil
    end
    parse_file(file)
  end

  def load_enrollment(key_and_file)
    d_bundle = []
    data_csv = parse_file(key_and_file.fetch(data_category(data_category_info))
    # data_csv = parse_file(key_and_file.fetch(:kindergarten))
    data_csv.each do |row|
      d_name = row[:location]
      data = row[:data]
      year = row[:timeframe]

      if find_by_name(d_name)
        d_object = find_by_name(d_name)


        d_object.kindergarten_participation.merge!({year => data})

      else
        new_instance = Enrollment.new({
          :name => d_name,
          data_category => { year => data }
          })
        @initial_statewide_testing_array << new_instance
        d_bundle << [d_name, new_instance]
      end
    end
    d_bundle
  end

  def find_by_name(d_name)
    initial_statewide_testing_array.detect do |test_instance|
      test_instance.name.upcase == d_name.upcase
    end
  end

end


# The StatewideTest instances are built using these data files:
#
# 3rd grade students scoring proficient or above on the CSAP_TCAP.csv
# 8th grade students scoring proficient or above on the CSAP_TCAP.csv
# Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv
# Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv
# Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv

# And I sketched out where testing and economic profile woudl be added though graduation isn’t a thing yet, but you might be able to figure out. I think it’s going to need just a big if loop. or enumerables if we can figure it out so we can set up the testing and economic repos by copying economic and changing the appropriate variables. you can give that a look if you want too
