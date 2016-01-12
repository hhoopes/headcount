
class District
  attr_reader :enrollment, :name

  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize(district)
    # @enrollment = Enrollment.new
    @name = district[:name]
  end

  def name
    district.fetch(:name).upcase
    #returns the upcased string name of the district
  end
end
