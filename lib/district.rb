class District
  attr_reader :name, :enrollment, :statewide_testing, :economic_profile
  attr_accessor :enrollment
  #an instance of this class looks like d = District.new({:name => "ACADEMY 20"})
  def initialize(district_hash)
    @name = district_hash[:name].upcase
    @enrollment = district_hash[:enrollment]
  end

  def link_data(data_object, data_key)
    case data_key
      when :enrollment
        @enrollment = data_object
      when :statewide_testing
        @statewide_testing = data_object
      when :economic_profile
        @economic_profile = data_object
    end
  end
end
