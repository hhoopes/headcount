require_relative './enrollment'
require_relative './district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :initial_enrollments_array, :unlinked_districts

  def initialize
    @initial_enrollments_array = []
    @unlinked_districts = []
  end

  def load_data(request_hash) #entry point for directly creating a repo
    request_hash.fetch(:enrollment).each do | data_type, file |
      load_enrollment(data_type, file)
    end
    unlinked_districts
  end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

  def load_enrollment(data_type, file) #entry point for district repo
    data_csv = parse_file(file)
    data_csv.each do |row|
      d_name = row[:location]
      data = row[:data].to_f
      year = row[:timeframe]
      d_object = find_by_name(d_name)
      if d_object
        case data_type
        when :kindergarten
          add_kindergarten(d_object, data, year)
        when :graduation
          add_graduation(d_object, data, year)
        end
      else # district doesn't exist, create instance
        create_new_district(data_type, d_name, year, data)
      end
    end
  end

  def add_kindergarten(d_object, data, year)
    if d_object.kindergarten.nil?
      d_object.kindergarten = {year => data}
    else #need to merge
      d_object.kindergarten.merge!({year => data})
    end
  end

  def add_graduation(d_object, data, year)
    if d_object.graduation.nil?
      d_object.graduation = {year => data}
    else
      d.object.graduation.merge!({year => data})
    end
  end

  def create_new_district(data_type, d_name, year, data)
    new_instance = Enrollment.new({
      :name => d_name,
      data_type => { year => data }
      })
    initial_enrollments_array << new_instance
    unlinked_districts << [d_name, new_instance]
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
