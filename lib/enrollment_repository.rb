$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'enrollment'
require 'district_repository'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollment

  def initialize
    @enrollment = []
  end

  # #{
  # :enrollment => {
  #   :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
  #   }
  # }
  def load_data(data)
    data_csv = parse_file(data)
    extracted_data = data_assignment(data_csv)
    new_enrollment(extracted_data)

  end

  def parse_file(data)
    data_info = get_data_info(data)
    data = CSV.open "./data/subsets/kindergarten_enrollment.csv", headers: true, header_converters: :symbol
    # data_info.fetch
    data
  end

  def get_data_info(argument)
    #get file and category info out of load_data calls
    info = {}
    argument.each do |key, value|
      info[:data_category] = key
      value.each do |key, value|
        info[:data_type] = key
        info[:file] = value
      end
    end
    info
  end

  def data_assignment(data_csv)
      data_csv.each do |row|
      # row.map { |row| [row.fetch(:key), row.fetch(:value)] }.map(&:to_h)
      district = row[:location]
      data = row[:data]
      year = row[:timeframe]
  end
  end

  def enrollment_exists?
    @enrollment_exists
  end

  def new_enrollment(data_collection)
    @enrollment_exists unless nil
     @enrollment.participation.merge!(participation_by_year)
     else @enrollment << Enrollment.new
      # doing a conditional that checks if enrollment exists, updates it by updating the existing enrollment object
      #if it doesn't exist create new enrollment object
      #merge!
      # ({:name => district, :kindergarten_participation => { year => data }})
  end

  def enrollment_exists
    # @enrollment.detect
    #   @enrollment == districts
    #   if true returns enrollment_data
    #     if false returns nil
  end

  def get_data_info(argument)
    #get file and category info out of load_data calls
    info = {}
    argument.each do |key, value|
      info[:data_category] = key
      value.each do |key, value|
        info[:data_type] = key
        info[:file] = value
      end
    end
    info
  end

  # def form_symbol(string)
  #   string.gsub(/\W/, "").upcase.to_sym
  # end

  def find_by_name(search)
      if enrollment.has_key?(search)
         enrollment.fetch(search)

      else nil
      end
#organizes the data by assigning each data file to a key and thus creating a hash
  end
end


er = EnrollmentRepository.new
er.load_data({ :enrollment => {  :kindergarten => "./data/subsets/kindergarten_enrollment.csv"}})
binding.pry
er.find_by_name("ADAMS-ARAPAHOE")
#initialization looks like this
#er = EnrollmentRepository.new

# functionality is that it will use a filter to find specific enrollment information. In this case, info about Academy 20's kindergarten enrollment for all years
#er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
