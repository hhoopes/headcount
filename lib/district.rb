
class District
  attr_reader :enrollment, :name

  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize(district_hash)
    @name = district_hash[:name].upcase

  end

end
