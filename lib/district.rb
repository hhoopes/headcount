class District
  attr_reader :name
  attr_accessor :enrollment
  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize(district_hash)
    @name = district_hash[:name].upcase
    @enrollment = district_hash[:enrollment]
  end
end
