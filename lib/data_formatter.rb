class DataFormatter
  attr_reader :bad_data, :data_category, :key_list

  def initialize(data_category)
    @bad_data = ["LNE", "#VALUE!", nil]
    @data_category = data_category
    @key_list = {
      :kindergarten                 => [:location, :data, :timeframe],
      :high_school_graduation       => [:location, :data, :timeframe],
      :third_grade                  => [:location, :data, :timeframe, :score],
      :eighth_grade                 => [:location, :data, :timeframe, :score],
      :math                         => [:location, :data, :timeframe, :raceethnicity],
      :reading                      => [:location, :data, :timeframe, :raceethnicity],
      :writing                      => [:location, :data, :timeframe, :raceethnicity],
      :median_household_income      => [:location, :data, :timeframe],
      :children_in_poverty          => [:location, :data, :timeframe, :dataformat],
      :free_or_reduced_price_lunch  => [:location, :data, :timeframe, :dataformat, :povertylevel],
      :title_i                      => [:location, :data, :timeframe]
      }
  end

  def format_data(request_hash)
    request_hash.fetch(data_category).map do | data_type, file |
      {data_type => load_csv(data_type, file)}
    end
  end

  def parse_file(file)
    CSV.open file,
             headers: true,
             header_converters: :symbol
  end

  def load_csv(data_type, file)
    data_csv = parse_file(file)
    data_csv.map do |row|
      row_hash = {}
      row.headers.each do |value|
        row_hash[value] = row[value]
       end
       row_hash
     end
  end
end
