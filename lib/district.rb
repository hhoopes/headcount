req 'csv'

class District
  attr_reader :enrollment

  def initialize({:name => district_name})
    @enrollment = Enrollment.new

  end

  def name
    #returns the upcased string name of the district

  end

end
