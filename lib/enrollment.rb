require 'csv'

  class Enrollment

    def initialize(name_with_category)
      #initalizes and passes in a hash within a hash
    end

    def kindergarten_participation
      kindergarten_data.each do |row|
        district = row[:location]
        puts district
      end
    end

  end


kindgarten_data = CSV.open '../data/Kindergartners in full-day program.csv', headers: true, header_converters: :symbol

data = {:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}}
e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
data[:kindergarten_participation][2010]

ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
#dividing first by colorado number


# 1] pry(main)> mraina = {"friends" => {"denver" => ["stephanie", "keji"], "vail" => ["jon", "lucy"]}}
# [2] pry(main)> mraina
# [3] pry(main)> mraina["friends"]
# [4] pry(main)> mraina["friends"]["denver"]
