class District
  attr_reader :name
  attr_accessor :data, :enrollment, :statewide_testing, :economic_profile, :statewide_test

  def initialize(data = {})
    @data = data
    @name = data[:name].upcase
    @statewide_test

  end

  def link_data(data_object, data_key)
    case data_key
      when :enrollment
        @enrollment = data_object
      when :statewide_testing || :statewide_test
        @statewide_testing = data_object
      when :economic_profile
        @economic_profile = data_object
    end
  end
end
