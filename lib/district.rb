req 'csv'

class District
  attr_reader :enrollment, :name, :district_name

  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize({:name => district_name})
    @enrollment = Enrollment.new

  end

  def name
    @name = name.upcase
    #returns the upcased string name of the district
  end

end
