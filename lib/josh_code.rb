require 'csv'

class CsvLoader
  def initialize(paths)
    @paths = paths
  end

  def load
   filename  = @paths[:enrollment][:kindergarten]
   rows      = CSV.readlines(filename, headers: true, header_converters: :symbol)

   district_data = {}

   rows.each do |row|
     name         = row[:location]
     district     = (district_data[row[:location]] ||= {name: name})
     enrollment   = (district[:enrollment_data]    ||= {name: name})
     kindergarten = (enrollment[:kindergarten_participation]     ||= {})
     kindergarten[row[:timeframe].to_i] = row[:data].to_f
   end

   district_data
  end
end


class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data(paths)
   district_data = CsvLoader.new(paths).load
   district_data.each { |name, data|
     district = District.new(data)
     @districts[name] = district
   }
  end

  def find_by_name(name)
    districts[name]
  end

  def find_all_matching(fragment)
    districts.select { |name, district| name[fragment] }
             .map { |name, district| district }
  end
end


class District
  def initialize(attrs={})
    @attrs = attrs
  end

  def name
    @attrs.fetch :name
  end
end



class Enrollment
  attr_reader :attrs
  def initialize(attrs={})
    @attrs = attrs
  end

  def name
    attrs.fetch :name
  end

  def kindergarten_participation_by_year
    attrs.fetch :kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end
end


class EnrollmentRepository
  attr_reader :enrollments
  def initialize
    @enrollments = {}
  end

  def load_data(paths)
    district_data = CsvLoader.new(paths).load
    district_data.each do |name, district|
      enrollment = Enrollment.new district[:enrollment_data]
      enrollments[name] = enrollment
    end
  end

  def find_by_name(name)
    enrollments[name]
  end
end
