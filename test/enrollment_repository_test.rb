
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'minitest'
# require './test/test_helper'
require 'enrollment_repository'
require 'enrollment'
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
      :kindergarten => "./data/Kindergartners in full-day program.csv"
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

  def test_load_data_works


  end

  def test_find_by_name_returns_enrollment_when_in_repo
    #??????????????????
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    query = "ADAMS-ARAPAHOE"
    find_by_name_output = er.find_by_name(query)

    # assert_equal query.upcase, find_by_name_output.last.last
    assert find_by_name_output.instance_of?(Enrollment)
  end

  def test_find_by_name_with_funky_characters_still_returns_district
    skip
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
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
    skip
    er = EnrollmentRepository.new
    er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    query ="brush RE-2(J)"

    assert_equal [0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1], er.find_by_name(query)
  end

end
