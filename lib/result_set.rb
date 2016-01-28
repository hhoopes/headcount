require_relative 'result_entry'
require 'pry'

class ResultSet
  attr_reader :matching_districts, :statewide_average

  def initialize(entries = [])
    @matching_districts = entries.fetch(:matching_districts)
    @statewide_average = entries.fetch(:statewide_average)
  end

end
