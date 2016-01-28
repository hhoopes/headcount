class DataFormatter
  attr_reader :exclude_data

  def initialize
    @exclude_data = ["LNE", "#VALUE!", nil, "Eligible for Reduced Lunch", "Eligible for Free Lunch"]
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
      when :kindergarten, :kindergarten_participation, :high_school_graduation, :title_i
        [format_kindergarten(data_type), hash[:location].upcase, {hash[:timeframe].to_i => hash[:data].to_f}]
      when :third_grade, :eighth_grade
        [format_number(data_type), hash[:location].upcase, {hash[:timeframe].to_i => {hash[:score].downcase.to_sym => format_score(hash[:data])}}]
      when :math, :reading, :writing
        [format_ethnicity(hash[:race_ethnicity]), hash[:location].upcase, {hash[:timeframe].to_i => {data_type => format_score(hash[:data])}}]
      when :median_household_income
        [data_type, hash[:location].upcase, {format_timeframe(hash[:timeframe]) => hash[:data].to_i}]
      when :free_or_reduced_price_lunch, :children_in_poverty
        [data_type, hash[:location].upcase, {hash[:timeframe].to_i => {format_lunch(hash[:dataformat]) => hash[:data].to_f}}]
      end
    end
    formatted
  end

  def format_timeframe(range)
    range.split("-").map {|year| year.to_i}
  end

  def format_number(num)
    if num == :third_grade
      3
    elsif num == :eighth_grade
      8
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

  def format_ethnicity(ethnicity)
    ethnicity.gsub(/\W+/, "").downcase.to_sym
  end

  def format_kindergarten(data_type)
    if data_type == :kindergarten
      :kindergarten_participation
    else data_type
    end
  end

  def format_score(number)
    Float(number)
      number.to_f
    rescue
      number
  end
end
