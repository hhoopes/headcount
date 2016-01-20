class DataFormatter
  attr_reader :bad_data

  def initialize
    @bad_data = ["LNE", "#VALUE!", nil]
  end
  #
  # def format_data(request_hash, data_category)
  # request_hash.fetch(data_category).each do | data_type, file |
  #   parsed = parse_file(file) with appropriate keys for type of data
  #   extract_data(parsed)
  #   return_hash = format_data
  # end
  #
  # def parse_file(file)
  #   all_data = CSV.open file,
  #            headers: true,
  #            header_converters: :symbol
  #   all_data
  # end
  #
  # def type_matcher(data_type)
  #   case data_type
  #   when :kindergarten_participation
  #     data = row[:data].to_f
  #     year = row[:timeframe].to_i
  #   when :high_school_graduation
  #   when
  # def load_testing(data_type, file) #entry point for district repo
  #   data_csv = parse_file(file)
  #   data_csv.each do |row|
  #     d_name = row[:location].upcase
  #     percent = row[:data]
  #     year = row[:timeframe].to_i
  #     subject = row[:score].to_s
  #
  #     return if formatter.bad_data.include?(percent)
  #       formatted_data = {:name => d_name, data_type => {year => {subject => percent}}}
  #       t_object = find_by_name(d_name)
  #       if t_object
  #         add_data(data_type, formatted_data, t_object)
  #       else # district doesn't exist, create instance
  #         create_new_statewide_test(formatted_data, d_name)
  #       end
  #   end
  # end
end
