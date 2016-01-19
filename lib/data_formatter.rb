class DataFormatter
  attr_reader :bad_data

  def initialize
    @bad_data = ["LNE", "#VALUE!", nil]
  end

#   request_hash.fetch(:statewide_testing).each do | data_type, file |
#     load_testing(data_type, file)
#   end
#
#     def parse_file(file)
#       CSV.open file,
#                headers: true,
#                header_converters: :symbol
#     end
#
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
#     end
  # end
end
