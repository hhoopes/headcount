require_relative './enrollment'
require_relative './data_formatter'
require 'csv'
require 'pry'

class EnrollmentRepository
  attr_reader :initial_enrollments_array, :unlinked_enroll, :formatter

  def initialize
    @initial_enrollments_array = []
    @unlinked_enroll = []
    @formatter = DataFormatter.new
  end

  def load_data(request_hash)
    enroll = request_hash.fetch(:enrollment)
      enroll.each do | data_type, file |
      formatted = formatter.format_data(data_type, file)
      sort_data(formatted)
    end
    unlinked_enroll
  end

  def sort_data(formatted)
    formatted.each do |hash|
      data_type       = hash.first
      location        = hash[1]
      formatted_hash  = hash.last
      en_object = find_by_name(location)
      if en_object
        add_data(formatted_hash, en_object, data_type)
      else
        create_new_instance(formatted_hash, location, data_type)
      end
    end
  end

  def add_data(hash, en_object, data_type)
    if en_object.data[data_type].nil?
      en_object.data[data_type] = hash
    else
      deep_merge!(en_object.data.fetch(data_type), hash)
    end
  end

  def create_new_instance(hash, location, data_type)
    new_instance = Enrollment.new({:name => location, data_type => hash})
    initial_enrollments_array << new_instance
    unlinked_enroll << [location, new_instance]
  end

  def find_by_name(d_name)
    initial_enrollments_array.detect do |e_instance|
      e_instance.name.upcase == d_name.upcase
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
