require_relative 'district_repository'


class HeadcountAnalyst
  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(d_name1, against_district)
    #couldn't we just d_name2 the second object
    d_name2 = against_district.fetch(:against) #d2 is assignment for second district
    d_object1 = get_district(d_name1)
    # #<District:0x007fb02e229a80
 # @enrollment=  #<Enrollment:0x007fb02e238fa8
 #   @high_school_graduation=nil,
 #   @kindergarten= {"2007"=>0.39159, "2006"=>0.35364, "2005"=>0.26709, "2004"=>0.30201,"2008"=>0.38456, "2009"=>0.39, "2010"=>0.43628, "2011"=>0.489, "2012"=>0.47883, "2013"=>0.48774, "2014"=>0.49022}, @name="ACADEMY 20">, @name="ACADEMY 20">
    d_object2 = get_district(d_name2)
    #<District:0x007f9bf696a980
 # @enrollment= #<Enrollment:0x007f9bf6a126f8  @high_school_graduation=nil,@kindergarten= {"2007"=>0.21756, "2006"=>0.11923, "2005"=>0.35254, "2004"=>0.30224, "2008"=>0.7658, "2009"=>0.98, "2010"=>0.99327, "2011"=>0.993, "2012"=>1.0, "2013"=>1.0, "2014"=>1.0}, @name="CANON CITY RE-1">, @name="CANON CITY RE-1">
    average1 = calculate_average_rate_for_all_years(d_object1)
    #0.4064509090909091
    average2 = calculate_average_rate_for_all_years(d_object2)
    #0.702149090909091
    truncate_float(average1/average2)
    #finds the variance between two districts
    #Example: ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1') # => 1.234
  end

  def kindergarten_participation_rate_variation_trend(d_name1, against_district)
    d_name2 = against_district.fetch(:against)
    d_object1 = get_district(d_name1)
    d_object2 = get_district(d_name2)
    average1 = calculate_average_rate(d_object1, d_object2)

    #iterates through the years and puts this in a hash
    #Example: ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO') # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }
  end

  def calculate_average_rate(d_object1, d_object2)
   if d_object1.enrollment.kindergarten && d_object2.enrollment.kindergarten
     data_hash1 = d_object1.enrollment.kindergarten
     data_hash2 = d_object2.enrollment.kindergarten
       index = 0
         while data_hash1.keys[index] == data_hash2.keys[index]
           annual_enrollment_hash = data_hash1.merge(data_hash2){|key, first, second| truncate_float(first/2.0) + truncate_float(second/2.0) }
         index += 1
       end

   end
  end


  def calculate_average_rate_for_all_years(d_object)
    if d_object.enrollment.kindergarten
  #     #if information about kindergarten enrollment exists within the d_object then:
      data = d_object.enrollment.kindergarten.values
  #     #creates hash with k values
  #     #[0.39159, 0.35364, 0.26709, 0.30201, 0.38456, 0.39, 0.43628, 0.489, 0.47883, 0.48774, 0.49022]
      data.inject(0) do |memo, datum|
        memo + datum
      end/data.size
  #     #adds the total
  #     #4.47096
  #     #then divide by the size of the array to find the average (below)
  #     #0.4064509090909091
    end
  end

  def get_district(d_name)
    district_repository.find_by_name(d_name)
  end

  def truncate_float(number)
    sprintf("%.3f", number).to_f
  end

end
