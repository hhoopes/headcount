require_relative './economic_profile'
require_relative './data_formatter'
require 'csv'
require 'pry'

class EconomicProfileRepository
  attr_reader :initial_eco_array, :unlinked_eco, :formatter

  def initialize
    @initial_eco_array = []
    @unlinked_eco = []
    @formatter = DataFormatter.new
  end

  def load_data(request_hash)
    eco = request_hash.fetch(:economic_profile)
      eco.each do | data_type, file |
      formatted = formatter.format_data(data_type, file)
      sort_data(formatted)
    end
    unlinked_eco
  end

  def sort_data(formatted)
    formatted.each do |hash|
      data_type       = hash.first
      location        = hash[1]
      formatted_hash  = hash.last
      e_object = find_by_name(location)
      if e_object
        add_data(formatted_hash, e_object, data_type)
      else
        create_new_instance(formatted_hash, location, data_type)
      end
    end
  end

  def add_data(hash, e_object, data_type)
    if e_object.data[data_type].nil?
      e_object.data[data_type] = hash
    else
      deep_merge!(e_object.data.fetch(data_type), hash)
    end
  end

  def create_new_instance(hash, location, data_type)
    new_instance = EconomicProfile.new({:name => location, data_type => hash})
    binding.pry
    initial_eco_array << new_instance
    unlinked_eco << [location, new_instance]
  end

  def find_by_name(d_name)
    initial_eco_array.detect do |eco_instance|
      eco_instance.name.upcase == d_name.upcase
    end
  end

  def deep_merge!(tgt_hash, src_hash)
    tgt_hash.merge!(src_hash) { |key, oldval, newval|
      if oldval.kind_of?(Hash) && newval.kind_of?(Hash)
        deep_merge!(oldval, newval)
      else
        newval
      end
    }
  end
end
