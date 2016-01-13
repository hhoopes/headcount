
class District
  attr_reader :enrollment, :name

  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize(district)
    @enrollment = Enrollment.new
    @name = (district[:name]).upcase
  end

end
