class DataFormatter
  attr_reader :exclude_data

  def initialize
    @exclude_data = ["LNE", "#VALUE!", nil, "N/A", "NA", "Eligible for Reduced Lunch", "Eligible for Free Lunch"]
  end

  def format_data(data_type, file)
    extracted = extract_csv(data_type, file)
    mapped = map_data(extracted, data_type)
  end

  def parse_file(file)
    CSV.open file, headers: true, header_converters: :symbol
  end

  def extract_csv(data_type, file)
    parse_file(file).map do |row|
      row_hash = {}
      row.headers.each do |value|
        if exclude_data.include?(row[value])
          row_hash = {}
          break
        end
        row_hash[value] = row[value]
       end
       row_hash
     end.reject{|hash| hash.empty? }
  end

  def map_data(array_of_hashes, data_type)
    formatted =
    array_of_hashes.map do | hash |
      case data_type
      when :kindergarten, :kindergarten_participation, :high_school_graduation, :children_in_poverty, :title_i
        [format_kindergarten(data_type), hash[:location].upcase, {hash[:timeframe].to_i => hash[:data].to_f}]
      when :third_grade, :eighth_grade
        [data_type, hash[:location].upcase, {hash[:timeframe].to_i => {hash[:score] => hash[:data].to_f}}]
      when :math, :reading, :writing
        # data_type = :raceethnicity
        # raceethnicity = hash.fetch(:data_type)
        [format_ethnicity(hash[:race_ethnicity]), hash[:location].upcase, {hash[:timeframe].to_i => {data_type => hash[:data].to_f}}]
      when :median_household_income
        [data_type, hash[:location].upcase, {hash[:timeframe].split => hash[:data]}]
      when :free_or_reduced_price_lunch
        [data_type, hash[:location].upcase, {hash[:timeframe].to_i => {format_lunch(hash[:dataformat]) => hash[:data].to_f}}]
      end
    end
    formatted
  end

  def format_lunch(dataformat)
    case dataformat
    when "Percent"
      :percentage
    when "Number"
      :total
    end
  end

  def format_ethnicity(ethnicity)
    ethnicity.gsub(" ", "").downcase.to_sym
  end

  def format_kindergarten(data_type)
    if data_type == :kindergarten
      :kindergarten_participation
    else data_type
    end
  end
end
