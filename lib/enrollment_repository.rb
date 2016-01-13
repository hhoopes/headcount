require_relative './enrollment'
require_relative './district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollment, :participation, :participation_by_year

  def initialize
    @enrollment = []
  end

  # #{
  # :enrollment => {
  #   :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
  #   }
  # }
  def load_data(request)
    file = parse_file(request)
    extracted_data = data_assignment(file)
    new_enrollment(extracted_data)

  end

  def parse_file(data)
    # data_info = get_data_info(data)
    data = CSV.open file, headers: true, header_converters: :symbol
    # data_info.fetch
    data
  end

  def get_data_info(argument)
  #   #get file and category info out of load_data calls
    file = ""
    argument.each do |key, value|
  #     info[:data_category] = key
      value.each do |key, value|
  #       info[:data_type] = key
        file = value
      end
    end
  #   info
  # end

  def data_assignment(data_csv)
      data_csv.each do |row|
      row.map { |row| [row.fetch(:key), row.fetch(:value)] }.map(&:to_h)
      district = row[:location]
      data = row[:data]
      year = row[:timeframe]
    end
  end

  def enrollment_exists?
    @enrollment_exists
  end

  def new_enrollment(data_collection)
    if @enrollment_exists(district)
      @enrollment.participation.merge!(participation_by_year)
    else @enrollment << Enrollment.new({:name => district, :kindergarten_participation => { year => data }})
      # doing a conditional that checks if enrollment exists, updates it by updating the existing enrollment object
      #if it doesn't exist create new enrollment object
      #merge!
      #
  end

   def enrollment_exists(district)
     @enrollment.detect do |enrollment_instance|
       enrollment_instance.name == district
     end
       if true returns enrollment_data
         if false returns nil
   end

  def find_by_name(search)
      if enrollment.has_key?(search)
         enrollment.fetch(search)
      else nil
      end
#organizes the data by assigning each data file to a key and thus creating a hash
  end
end


# er = EnrollmentRepository.new
# er.load_data({ :enrollment => {  :kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
# binding.pry
# er.find_by_name("ADAMS-ARAPAHOE")
# initialization looks like this
# er = EnrollmentRepository.new

# functionality is that it will use a filter to find specific enrollment information. In this case, info about Academy 20's kindergarten enrollment for all years
#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
