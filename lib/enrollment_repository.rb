require_relative './enrollment'
# require_relative './data_formatter'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :initial_enrollments_array, :unlinked_enrollments

  def initialize
    @initial_enrollments_array = []
    @unlinked_enrollments = []
    # @formatter = DataFomatter.new(:enrollment)
  end

  def load_data(request_hash) #entry point for directly creating a repo
    request_hash.fetch(:enrollment).each do | data_type, file |
      load_enrollment(data_type, file)
    end
    unlinked_enrollments
  end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

  def load_enrollment(data_type, file) #entry point for district repo
    data_type = :kindergarten_participation if data_type == :kindergarten
    data_csv = parse_file(file)
    data_csv.each do |row|
      d_name = row[:location].upcase
      data = row[:data].to_f
      year = row[:timeframe].to_i
      e_object = find_by_name(d_name)
      if e_object
        case data_type
        when :kindergarten_participation
          add_kindergarten(e_object, data, year)
        when :high_school_graduation
          add_graduation(e_object, data, year)
        end
      else # district doesn't exist, create instance
        create_new_enrollment(data_type, d_name, year, data)
      end
    end
  end

  def add_kindergarten(e_object, data, year)
    e_object.data[:kindergarten_participation].merge!({year => data})
  end

  def add_graduation(e_object, data, year)
    e_object.data[:high_school_graduation].merge!({year => data})
  end

  def create_new_enrollment(data_type, d_name, year, data)
    new_instance = Enrollment.new({data_type => {year => data}, :name => d_name} )
    initial_enrollments_array << new_instance
    unlinked_enrollments << [d_name, new_instance]
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
