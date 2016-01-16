require 'minitest'
require './lib/enrollment_repository'
require './lib/enrollment'
require 'pry'

class EnrollmentRepositoryTest < Minitest::Test

  def test_instantiates_an_enrollment_class
    enroll_repo = EnrollmentRepository.new
    assert enroll_repo.instance_of?(EnrollmentRepository)
  end

  # def test_load_data_takes_a_data_request_and_returns_an_array_of_district_instances_and_names
  #   er = EnrollmentRepository.new
  #   array = er.load_data({
  #   :enrollment => {
  #     :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
  #     }
  #   })
  #   popped_element = array.pop
  #   assert popped_element.instance_of?(Enrollment)
  # end

  def parse_file_returns_an_instance_of_CSV
    er = EnrollmentRepository.new
    parsed = er.parse_file(:enrollment=>{:kindergarten=>"./data/subsets/kindergarten_enrollment.csv"})
    assert parsed.instance_of?(CSV)
  end

  # def test_loading_district_to_repo_adds_it_to_array
  #   er = EnrollmentRepository.new
  #   assert er.initial_enrollments_array.empty?
  #   output1 = er.load_enrollment(["Colorado"])
  #   assert_equal 1, er.initial_enrollments_array.length
  #
  #   output2 = er.load_enrollment(["ACADEMY 20"])
  #
  #   assert_equal 2, er.initial_enrollments_array.length
  # end

  # def test_loading_district_overwrites_same_name
  #   er = EnrollmentRepository.new
  #   output1 = er.load_enrollment(["Colorado"])
  #   assert_equal 1, er.initial_enrollments_array.length
  #
  #   output2 = er.load_enrollment(["Colorado"])
  #
  #   assert_equal 1, er.initial_enrollments_array.length
  # end

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

    # assert_equal query.upcase, find_by_name_output.last.last
    assert find_by_name_output.instance_of?(Enrollment)

    query ="BRUSH RE-2(J)"
    find_by_name_output = er.find_by_name(query)
    #
    # assert_equal query.upcase, find_by_name_output.last.last
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
