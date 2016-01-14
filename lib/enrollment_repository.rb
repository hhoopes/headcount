require_relative './enrollment'
require_relative './district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments, :participation, :participation_by_year, :year, :district, :data

  def initialize
    @enrollments = []
  end

  def load_data(request)
    file = parse_file(request)
    extracted_data = data_assignment(file)
  end

  def parse_file(data)
    file = get_data_info(data)
    data = CSV.open file, headers: true, header_converters: :symbol
    data
  end

  def get_data_info(argument)
    file = ""
    argument.each do |key, value|
      # info[:data_category] = key
      value.each do |key, value|
        # info[:data_type] = key
        file = value
      end
    end
    file
  end

  def data_assignment(data_csv)
    data_csv.each do |row|
        # binding.pry
      district = row[:location]
      data = row[:data]
      year = row[:timeframe]
      if enrollment = find_by_name(district)
        enrollment.participation.merge!({year => data})
        #enrollment_exists? returns an enrollment instance or nil, assign that returned value to the local variable 'enrollment' and then execute our if/ else logic on it.
      else
        @enrollments << Enrollment.new({:name => district, :kindergarten_participation => { year => data }})
      end
    end
  end
      # doing a conditional that checks if enrollment exists, updates it by updating the existing enrollment object
      #if it doesn't exist create new enrollment object
      #merge!

  #  def enrollment_exists?(district)
  #    @enrollments.detect do |enrollment_instance|
  #      enrollment_instance.name == district
  #    end
  #  end
      #  if true returns enrollment_data
        #  if false returns nil

  def find_by_name(d_name)
    @enrollments.detect do |enrollment_instance|
      enrollment_instance.name == d_name
    end
  end
#organizes the data by assigning each data file to a key and thus creating a hash
end
# functionality is that it will use a filter to find specific enrollment information. In this case, info about Academy 20's kindergarten enrollment for all years
#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
