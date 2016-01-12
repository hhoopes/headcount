req 'csv'

class District
  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  attr_reader :enrollment

  def initialize({:name => district_name})
    @enrollment = Enrollment.new

  end

  def name
    #returns the upcased string name of the district

  end

end
