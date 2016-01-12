require 'csv'

class Enrollment
#   Enrollment: Gives access to enrollment data within that district, including:
# |  | -- Dropout rate information
# |  | -- Kindergarten enrollment rates
# |  | -- Online enrollment rates
# |  | -- Overall enrollment rates
# |  | -- Enrollment rates by race and ethnicity
# |  | -- High school graduation rates by race and ethnicity
# |  | -- Special education enrollment rates

    def initialize(name_with_category)
      #initalizes and passes in a hash within a hash
    end

    def kindergarten_participation(kindergarten_data)
      kindergarten_data.each do |row|
        district = row[:location]
        puts district
      end
    end

    def kindergarten_participation_in_year(year)
    end

end





# data = {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
# e = Enrollment.new({:name => "ACADEMY 20"}, :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
# data[:kindergarten_participation][2010]

# ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
#dividing first by colorado number


# 1] pry(main)> mraina = {"friends" => {"denver" => ["stephanie", "keji"], "vail" => ["jon", "lucy"]}}
# [2] pry(main)> mraina
# [3] pry(main)> mraina["friends"]
# [4] pry(main)> mraina["friends"]["denver"]
