req 'csv'

class District
  attr_reader :enrollment, :name, :district_name

  def initialize({:name => district_name})
    @enrollment = Enrollment.new

  end

  def name
    @name = name.upcase
    #returns the upcased string name of the district

  end

end
