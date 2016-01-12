
class District
  attr_reader :enrollment

  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize(district)
    # @enrollment = Enrollment.new
    @district_name = district[:name]
  end

  def name
    @name = name.upcase
    #returns the upcased string name of the district
  end
end
