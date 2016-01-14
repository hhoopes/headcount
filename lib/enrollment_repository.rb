require_relative './enrollment'
require_relative './district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :initial_enrollments_array

  def initialize
    @initial_enrollments_array = []
  end

  def load_data(request_with_file_and_data_info)
    csv_data = parse_file(request_with_file_and_data_info)
    load_enrollment(csv_data)
  end

  def parse_file(request)
    CSV.open request[:enrollment][:kindergarten], headers: true,header_converters: :symbol
  end

  def load_enrollment(data_csv)
    data_csv.each do |row|
      district = row[:location]
      data = row[:data]
      year = row[:timeframe]
      if enrollment = find_by_name(district)
        enrollment.kindergarten_participation.merge!({year => data})
      else
        @initial_enrollments_array << Enrollment.new({:name => district, :kindergarten_participation => { year => data }})
      end
    end
  end

  def find_by_name(d_name)
    initial_enrollments_array.detect do |enrollment_instance|
      enrollment_instance.name.upcase == d_name.upcase
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
