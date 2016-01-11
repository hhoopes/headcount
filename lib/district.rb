req 'csv'

class District
  attr_reader :enrollment

  def initialize
    @enrollment = Enrollment.new

  end

  def name
    #returns the upcased string name of the district
    
  end

end
