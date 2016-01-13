require_relative './enrollment'
require_relative './district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollment, :participation, :participation_by_year, :year, :district, :data

  def initialize
    @enrollment = []
  end

  #
  # {
  # :enrollment => {
  #    => "./data/subsets/kindergarten_enrollment.csv"
  #   }
  # }
  def load_data(request)
    file = parse_file(request)
    extracted_data = data_assignment(file)
    new_enrollment(extracted_data)

  end

  def parse_file(data)
    file = get_data_info(data)
    data = CSV.open file, headers: true, header_converters: :symbol
    # data_info.fetch
    data
  end

  def get_data_info(argument)
  #   #get file and category info out of load_data calls
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
        binding.pry
      district = row[:location]
      data = row[:data]
      year = row[:timeframe]
    end
  end

  def new_enrollment(data_collection)
    if enrollment_exists?(district)
      @enrollment.participation.merge!({year => data})
    else
      @enrollment << Enrollment.new({:name => district, :kindergarten_participation => { year => data }})
      # doing a conditional that checks if enrollment exists, updates it by updating the existing enrollment object
      #if it doesn't exist create new enrollment object
      #merge!
      #
    end
   end

   def enrollment_exists?(district)
     result = @enrollment.detect do |enrollment_instance|
       enrollment_instance.name == district
     end
     !result.empty?

      #  if true returns enrollment_data
        #  if false returns nil
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
