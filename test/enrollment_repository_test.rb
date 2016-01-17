require 'minitest'
require './lib/enrollment_repository'
require './lib/enrollment'
require 'pry'

class EnrollmentRepositoryTest < Minitest::Test

  def test_instantiates_an_enrollment_class
    enroll_repo = EnrollmentRepository.new
    assert enroll_repo.instance_of?(EnrollmentRepository)
  end

  def parse_file_returns_an_instance_of_CSV
    er = EnrollmentRepository.new
    parsed = er.parse_file(:enrollment=>{:kindergarten=>"./data/subsets/kindergarten_enrollment.csv"})
    assert parsed.instance_of?(CSV)
  end



  def test_adding_more_data_for_same_district_doesnt_overwite_first
  end

  def test_can_create_enrollment_repo_from_direct_hash_data
    skip(msg = "Will work once we extract a new method in load_enrollment that takes over from the if-loop on")
    er = EnrollmentRepository.new #won't be this method
    data1 = er.load_enrollment({
        :name => "Colorado",
        :enrollment => {:kindergarten =>
          {2013 => 0.23}}
        })
    assert_equal 1, er.initial_enrollments_array.length

    data2 = er.load_enrollment({
        :name => "Colorado",
        :enrollment => {:kindergarten =>
          {2014 => 0.33}}
        })
    output = ""
    assert_equal 1, er.initial_enrollments_array.length
    assert_equal output, er.kindergarten_participation_by_year
  end

  def test_find_by_name_returns_nil_for_query_not_in_repo
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    find_by_name_output = er.find_by_name("Marshmallows")
    assert_nil find_by_name_output
  end


  def test_find_by_name_returns_an_instance_of_enrollment
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    query = "JEFFERSON COUNTY R-1"

    assert_equal Enrollment, er.find_by_name(query).class
  end

  def test_find_by_name_with_funky_characters_still_returns_district
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    query = "ACADEMY 20"
    find_by_name_output = er.find_by_name(query)
    assert find_by_name_output.instance_of?(Enrollment)

    query ="BRUSH RE-2(J)"
    find_by_name_output = er.find_by_name(query)
    assert find_by_name_output.instance_of?(Enrollment)
  end

  def test_find_by_name_is_case_insensitive
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    query ="brush RE-2(J)"
    assert er.find_by_name(query).instance_of? Enrollment
    assert_equal "BRUSH RE-2(J)", er.find_by_name(query).name
  end


  def test_load_data_will_take_second_data_file
    skip
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    find_by_name_hash = er.find_by_name("ACADEMY 20")
    assert find_by_name_hash.high_school_graduation
  end

end
