require 'csv'

class StatewideTestingRepository

  def find_by_name

  end

end
# The StatewideTest instances are built using these data files:
#
# 3rd grade students scoring proficient or above on the CSAP_TCAP.csv
# 8th grade students scoring proficient or above on the CSAP_TCAP.csv
# Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv
# Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv
# Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv

# And I sketched out where testing and economic profile woudl be added though graduation isn’t a thing yet, but you might be able to figure out. I think it’s going to need just a big if loop. or enumerables if we can figure it out so we can set up the testing and economic repos by copying economic and changing the appropriate variables. you can give that a look if you want too
