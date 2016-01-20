class DataFormatter
  attr_reader :exclude_data, :data_category, :key_list

  def initialize(data_category)
    @exclude_data = ["LNE", "#VALUE!", nil, "N/A", "NA", "Eligible for Reduced Lunch", "Eligible for Free Lunch"]
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
      extracted = extract_csv(data_type, file)
      binding.pry
      map_data(extracted, data_type)
      end
  end

  def parse_file(file)
    CSV.open file, headers: true, header_converters: :symbol
  end

  def extract_csv(data_type, file)
    parse_file(file).map do |row|
      row_hash = {}
      row.headers.each do |value|
        if exclude_data.include?(row[value])
          row_hash = nil
          break
        end
        row_hash[value] = row[value]
       end
       row_hash
     end
  end

  def map_data(array_of_hashes, data_type)
    formatted = {}
    array_of_hashes.map do | hash |
      case data_type
      when :kindergarten, :kindergarten_participation, :high_school_graduation, :children_in_poverty, :title_i
        {:name => hash[:location], data_type => {hash[:timeframe] => hash[:data]}}
      when :third_grade, :eighth_grade
        formatted = {:name => hash[:location], data_type => {hash[:timeframe] => {hash[:score] => hash[:data]}}}
      when :math, :reading, :writing
        {:name => hash[:location], hash[:raceethnicity] => {hash[:timeframe] => {data_type => hash[:data]}}}
      when :median_household_income
        {:name => hash[:location], data_type => {hash[:timeframe].split => hash[:data]}}
      when :free_or_reduced_price_lunch
        {:name => hash[:location], data_type => {hash[:timeframe] => {format_lunch(hash[:dataformat]) => hash[:data]}}}
      end
    end
  end

  def format_lunch(dataformat)
    case dataformat
    when "Percent"
      :percentage
    when "Number"
      :total
    end
  end

end
