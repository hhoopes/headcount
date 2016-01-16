require 'minitest'
# require './test/test_helper'
require './lib/statewide_testing_repository'
require 'pry'

class StatewideTestingRepositoryTest < Minitest::Test
  def statewide_testing_repository_is_initialized
    str = StatewideTestRepository.new
    assert str.instance_of?(StatewideTestRepository)
  end

  def statewide_testing_repository_loads_data_gives_testing_information_for_multiple_categories_within_a_school
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  assert_equal  str = str.find_by_name("ACADEMY 20")

Edge cases:
LNE instead of Percent, percent out of order, 
  #3rd grade
  # ACADEMY 20,Math,2008,Percent,0.857
  # ACADEMY 20,Math,2009,Percent,0.824
  # ACADEMY 20,Math,2010,Percent,0.849
  # ACADEMY 20,Reading,2008,Percent,0.866
  # ACADEMY 20,Reading,2009,Percent,0.862
  # ACADEMY 20,Reading,2010,Percent,0.864
  # ACADEMY 20,Writing,2008,Percent,0.671
  # ACADEMY 20,Writing,2009,Percent,0.706
  # ACADEMY 20,Writing,2010,Percent,0.662
  # ACADEMY 20,Math,2011,Percent,0.819
  # ACADEMY 20,Reading,2011,Percent,0.867
  # ACADEMY 20,Writing,2011,Percent,0.678
  # ACADEMY 20,Reading,2012,Percent,0.87
  # ACADEMY 20,Math,2012,Percent,0.83
  # ACADEMY 20,Writing,2012,Percent,0.65517
  # ACADEMY 20,Math,2013,Percent,0.8554
  # ACADEMY 20,Math,2014,Percent,0.8345
  # ACADEMY 20,Reading,2013,Percent,0.85923
  # ACADEMY 20,Reading,2014,Percent,0.83101
  # ACADEMY 20,Writing,2014,Percent,0.63942
  # ACADEMY 20,Writing,2013,Percent,0.6687

  #8th grade
  # ACADEMY 20,Math,2008,Percent,0.64
  # ACADEMY 20,Math,2009,Percent,0.656
  # ACADEMY 20,Math,2010,Percent,0.672
  # ACADEMY 20,Reading,2008,Percent,0.843
  # ACADEMY 20,Reading,2009,Percent,0.825
  # ACADEMY 20,Reading,2010,Percent,0.863
  # ACADEMY 20,Writing,2008,Percent,0.734
  # ACADEMY 20,Writing,2009,Percent,0.701
  # ACADEMY 20,Writing,2010,Percent,0.754
  # ACADEMY 20,Reading,2011,Percent,0.83221
  # ACADEMY 20,Math,2011,Percent,0.65339
  # ACADEMY 20,Math,2012,Percent,0.68197
  # ACADEMY 20,Writing,2011,Percent,0.74579
  # ACADEMY 20,Writing,2012,Percent,0.73839
  # ACADEMY 20,Reading,2012,Percent,0.83352
  # ACADEMY 20,Math,2013,Percent,0.6613
  # ACADEMY 20,Math,2014,Percent,0.68496
  # ACADEMY 20,Reading,2013,Percent,0.85286
  # ACADEMY 20,Reading,2014,Percent,0.827
  # ACADEMY 20,Writing,2013,Percent,0.75069
  # ACADEMY 20,Writing,2014,Percent,0.74789
  #Math by race
  # ACADEMY 20,All Students,2011,Percent,0.68
  # ACADEMY 20,Asian,2011,Percent,0.8169
  # ACADEMY 20,Black,2011,Percent,0.4246
  # ACADEMY 20,Hawaiian/Pacific Islander,2011,Percent,0.5686
  # ACADEMY 20,Hispanic,2011,Percent,0.5681
  # ACADEMY 20,Native American,2011,Percent,0.6143
  # ACADEMY 20,Two or more,2011,Percent,0.6772
  # ACADEMY 20,White,2011,Percent,0.7065
  # ACADEMY 20,All Students,2012,Percent,0.6894
  # ACADEMY 20,Asian,2012,Percent,0.8182
  # ACADEMY 20,Black,2012,Percent,0.4248
  # ACADEMY 20,Hawaiian/Pacific Islander,2012,Percent,0.5714
  # ACADEMY 20,Hispanic,2012,Percent,0.5722
  # ACADEMY 20,Native American,2012,Percent,0.5714
  # ACADEMY 20,Two or more,2012,Percent,0.6899
  # ACADEMY 20,White,2012,Percent,0.7135
  # ACADEMY 20,All Students,2013,Percent,0.69683
  # ACADEMY 20,Asian,2013,Percent,0.8053
  # ACADEMY 20,Black,2013,Percent,0.4404
  # ACADEMY 20,Hawaiian/Pacific Islander,2013,Percent,0.6833
  # ACADEMY 20,Hispanic,2013,Percent,0.5883
  # ACADEMY 20,Native American,2013,Percent,0.5932
  # ACADEMY 20,Two or more,2013,Percent,0.6967
  # ACADEMY 20,White,2013,Percent,0.7208
  # ACADEMY 20,All Students,2014,Percent,0.69944
  # ACADEMY 20,Asian,2014,Percent,0.8
  # ACADEMY 20,Black,2014,Percent,0.4205
  # ACADEMY 20,Hawaiian/Pacific Islander,2014,Percent,0.6818
  # ACADEMY 20,Hispanic,2014,Percent,0.6048
  # ACADEMY 20,Native American,2014,Percent,0.5439
  # ACADEMY 20,Two or more,2014,Percent,0.6932
  # ACADEMY 20,White,2014,Percent,0.723

  #Reading by race
  # ACADEMY 20,All Students,2011,Percent,0.83
  # ACADEMY 20,Asian,2011,Percent,0.8976
  # ACADEMY 20,Black,2011,Percent,0.662
  # ACADEMY 20,Hawaiian/Pacific Islander,2011,Percent,0.7451
  # ACADEMY 20,Hispanic,2011,Percent,0.7486
  # ACADEMY 20,Native American,2011,Percent,0.8169
  # ACADEMY 20,Two or more,2011,Percent,0.8419
  # ACADEMY 20,White,2011,Percent,0.8513
  # ACADEMY 20,All Students,2012,Percent,0.84585
  # ACADEMY 20,Asian,2012,Percent,0.89328
  # ACADEMY 20,Black,2012,Percent,0.69469
  # ACADEMY 20,Hawaiian/Pacific Islander,2012,Percent,0.83333
  # ACADEMY 20,Hispanic,2012,Percent,0.77167
  # ACADEMY 20,Native American,2012,Percent,0.78571
  # ACADEMY 20,Two or more,2012,Percent,0.84584
  # ACADEMY 20,White,2012,Percent,0.86189
  # ACADEMY 20,All Students,2013,Percent,0.84505
  # ACADEMY 20,Asian,2013,Percent,0.90193
  # ACADEMY 20,Black,2013,Percent,0.66951
  # ACADEMY 20,Hawaiian/Pacific Islander,2013,Percent,0.86667
  # ACADEMY 20,Hispanic,2013,Percent,0.77278
  # ACADEMY 20,Native American,2013,Percent,0.81356
  # ACADEMY 20,Two or more,2013,Percent,0.85582
  # ACADEMY 20,White,2013,Percent,0.86083
  # ACADEMY 20,All Students,2014,Percent,0.84127
  # ACADEMY 20,Asian,2014,Percent,0.85531
  # ACADEMY 20,Black,2014,Percent,0.70387
  # ACADEMY 20,Hawaiian/Pacific Islander,2014,Percent,0.93182
  # ACADEMY 20,Hispanic,2014,Percent,0.00778
  # ACADEMY 20,Native American,2014,Percent,0.00724
  # ACADEMY 20,Two or more,2014,Percent,0.00859
  # ACADEMY 20,White,2014,Percent,0.00856
 #  #writing by race
 # ACADEMY 20,All Students,2011,Percent,0.83
 # ACADEMY 20,Asian,2011,Percent,0.8976
 # ACADEMY 20,Black,2011,Percent,0.662
 # ACADEMY 20,Hawaiian/Pacific Islander,2011,Percent,0.7451
 # ACADEMY 20,Hispanic,2011,Percent,0.7486
 # ACADEMY 20,Native American,2011,Percent,0.8169
 # ACADEMY 20,Two or more,2011,Percent,0.8419
 # ACADEMY 20,White,2011,Percent,0.8513
 # ACADEMY 20,All Students,2012,Percent,0.84585
 # ACADEMY 20,Asian,2012,Percent,0.89328
 # ACADEMY 20,Black,2012,Percent,0.69469
 # ACADEMY 20,Hawaiian/Pacific Islander,2012,Percent,0.83333
 # ACADEMY 20,Hispanic,2012,Percent,0.77167
 # ACADEMY 20,Native American,2012,Percent,0.78571
 # ACADEMY 20,Two or more,2012,Percent,0.84584
 # ACADEMY 20,White,2012,Percent,0.86189
 # ACADEMY 20,All Students,2013,Percent,0.84505
 # ACADEMY 20,Asian,2013,Percent,0.90193
 # ACADEMY 20,Black,2013,Percent,0.66951
 # ACADEMY 20,Hawaiian/Pacific Islander,2013,Percent,0.86667
 # ACADEMY 20,Hispanic,2013,Percent,0.77278
 # ACADEMY 20,Native American,2013,Percent,0.81356
 # ACADEMY 20,Two or more,2013,Percent,0.85582
 # ACADEMY 20,White,2013,Percent,0.86083
 # ACADEMY 20,All Students,2014,Percent,0.84127
 # ACADEMY 20,Asian,2014,Percent,0.85531
 # ACADEMY 20,Black,2014,Percent,0.70387
 # ACADEMY 20,Hawaiian/Pacific Islander,2014,Percent,0.93182
 # ACADEMY 20,Hispanic,2014,Percent,0.00778
 # ACADEMY 20,Native American,2014,Percent,0.00724
 # ACADEMY 20,Two or more,2014,Percent,0.00859
 # ACADEMY 20,White,2014,Percent,0.00856
  end

end
