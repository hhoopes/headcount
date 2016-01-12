class EnrollmentRepository
  #top level interface to query (search) for information by district name


  def find_by_name
    # returns either nil or an instance of Enrollment having done a case insensitive search
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
