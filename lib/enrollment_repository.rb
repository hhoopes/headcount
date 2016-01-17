require_relative './enrollment'
require_relative './district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :initial_enrollments_array

  def initialize
    @initial_enrollments_array = []
  end

  def load_data(request_hash) #entry point for directly creating a repo
    request_hash.fetch(:enrollment).each do | data_type, file |
    # key_and_file = get_key_and_file(request_hash)
      load_enrollment(data_type, file)
    end
  end

  # def get_key_and_file(hash) #method to sync up two different load methods
  #   hash.fetch(:enrollment)
  # end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

  def load_enrollment(data_type, file) #entry point for district repo
    d_bundle = []
    data_csv = parse_file(file)
    data_csv.each do |row|
      d_name = row[:location]
      data = row[:data].to_f
      year = row[:timeframe]
      if find_by_name(d_name) &&  find_by_name(d_name).enrollment #district exists, merge data
        d_object = find_by_name(d_name)
        d_object.enrollment.merge!({data_type => {year => data}})
      else # district doesn't exist, create instance
        new_instance = Enrollment.new({
          :name => d_name,
          data_type => { year => data }
          })
        @initial_enrollments_array << new_instance
        d_bundle << [d_name, new_instance] #add data to send back to district repo
      end
    end
    d_bundle
  end

  def find_by_name(d_name)
    initial_enrollments_array.detect do |enrollment_instance|
      enrollment_instance.name.upcase == d_name.upcase
    end
  end
end


#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
