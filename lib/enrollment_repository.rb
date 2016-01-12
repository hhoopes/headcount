 require 'district_repository'
require 'csv'

class EnrollmentRepository
  attr_reader :districts

  def initialize
  @districts = {}
  end
  #top level interface to query (search) for information by district name
  def load_data(data)
    data_info = get_data_info(data)
    data_csv = CSV.open data_info.fetch(:file), headers: true, header_converters: :symbol
    data_csv.each do |row|
      district = row[:data]
      symbol = form_symbol(district)
      @districts[symbol] = District.new({:name => district})
      #eventually change symbol and the initialization to an if statement based on get_data_info
    end
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

  def form_symbol(string)
    string.gsub(/\W/, "").upcase.to_sym
  end

  def find_by_name(search)
    # returns either nil or an instance of Enrollment having done a case insensitive search
    search_symbol = form_symbol(search)
    districts.fetch(search_symbol)
  end

#organizes the data by assigning each data file to a key and thus creating a hash
end

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
