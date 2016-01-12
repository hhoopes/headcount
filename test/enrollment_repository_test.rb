
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require 'minitest'
# require './test/test_helper'
require 'enrollment_repository'
require 'pry'

class EnrollmentRepositoryTest < Minitest::Test

  def test_instantiates_an_enrollment_class
    enroll_repo = EnrollmentRepository.new
    assert enroll_repo.instance_of?(EnrollmentRepository)
  end

  def test_find_by_name_returns_nil_for_query_not_in_repo
    # skip
    e = EnrollmentRepository.new
    e.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    find_by_name_output = e.find_by_name("Marshmallows")
    assert_nil find_by_name_output
  end

  def test_data_in_and_out_is_santized_for_consistency_and_to_be_symbols
    skip
    e = EnrollmentRepository.new
    assert_equal :_JAJA, e.form_symbol("-_ jaJA")
    assert_equal :FFFF, e.form_symbol("@FFff ++~")
    assert_equal :LOWERCASE, e.form_symbol("lowercase")
  end

  def test_find_by_name_returns_district_when_in_repo
    skip
    e = EnrollmentRepository.new
    e.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    query = "Colorado"
    find_by_name_output = e.find_by_name(query)

    # assert_equal query.upcase, find_by_name_output.last.last
    assert find_by_name_output.instance_of?(Enrollment)
  end

  def test_find_by_name_with_funky_characters_still_returns_district
    skip
    e = EnrollmentRepository.new
    e.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    query = "ACADEMY 20"
    find_by_name_output = e.find_by_name(query)

    #
    # assert_equal query.upcase, find_by_name_output.last.last
    assert find_by_name_output.instance_of?(Enrollment)

    query ="BRUSH RE-2(J)"
    find_by_name_output = e.find_by_name(query)
    #
    # assert_equal query.upcase, find_by_name_output.last.last
    assert find_by_name_output.instance_of?(Enrollment)
  end

  def test_find_by_name_is_case_insensitive
    skip
    e = EnrollmentRepository.new
    e.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    query ="brush RE-2(J)"

    assert_equal "AFD", e.find_by_name(query)
  end


  def test_find_all_matching_returns_possible_district_options_for_fragment_search
    skip
    e = EnrollmentRepository.new
    output = e.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert_equal ["CENTENNIAL R-1", "CENTER 26 JT"], e.find_all_matching("CEN")
  end


    def test_find_all_matching_returns_possible_district_options_for_fragment_search_lowercase
      skip
      e = EnrollmentRepository.new
      output = e.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })

      assert_equal ["CENTENNIAL R-1", "CENTER 26 JT"], e.find_all_matching("cen")
    end

    def test_find_all_matching_returns_empty_array_if_no_matches
      skip
      e = EnrollmentRepository.new
      output = e.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })

      assert_equal [], e.find_all_matching("XW")
    end

end
