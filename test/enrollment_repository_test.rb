require 'minitest'
require './lib/enrollment_repository'
require './lib/enrollment'
require 'pry'

class EnrollmentRepositoryTest < Minitest::Test

  def test_instantiates_an_enrollment_class
    enroll_repo = EnrollmentRepository.new
    assert enroll_repo.instance_of?(EnrollmentRepository)
  end

  def test_find_by_name_returns_nil_for_query_not_in_repo
    # skip
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/subsets/kindergarten_enrollment.csv"
      }
    })
    find_by_name_output = er.find_by_name("Marshmallows")
    assert_nil find_by_name_output
  end

  def test_data_in_and_out_is_santized_for_consistency_and_to_be_symbols
    er = EnrollmentRepository.new
    assert_equal :_JAJA, er.form_symbol("-_ jaJA")
    assert_equal :FFFF, er.form_symbol("@FFff ++~")
    assert_equal :LOWERCASE, er.form_symbol("lowercase")
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

end
