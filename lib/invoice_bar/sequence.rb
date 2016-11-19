# Example:
#   Sequence.new(from: 'VF201601010001', format: ['VF', :year, :month, :day]).nextn(by: :month)
module InvoiceBar
  class Sequence
    class ParseError < StandardError; end

    def initialize(from:, format: [:year, :month])
      @value = from || create_sequence(format)
      @format = format
      parse_format
    end

    def nextn(by: nil)
      @by = by
      next_value = String.new
      @date = Time.now

      @format.each do |part|
        case part
        when :year
          next_value << @date.strftime("%Y")
        when :y
          next_value << @date.strftime("%y")
        when :month
          next_value << @date.strftime("%m")
        when :day
          next_value << @date.strftime("%d")
        when :number
          next_value << @number
        else
          next_value << part
        end
      end
      next_value << next_number_with_zeros
    end

    private

    # Creates a first number in sequece according to +format+
    def create_sequence(sequence_format)
      sequence = String.new
      date = Time.now

      sequence_format.each do |part|
        case part
        when :year
          sequence << date.strftime("%Y")
        when :y
          sequence << date.strftime("%y")
        when :month
          sequence << date.strftime("%m")
        when :day
          sequence << date.strftime("%d")
        else
          sequence << part
        end
      end

      sequence << '00001'
    end

    def parse_format
      index = 0

      @format.each do |part|
        case part
        when :year
          @year = @value[index..(index + 3)]
          index += 4
        when :y
          @year = @value[index..(index + 1)]
          index += 2
        when :month
          @month = @value[index..(index + 1)]
          index += 2
        when :day
          @day = @value[index..(index + 1)]
          index += 2
        else
          raise ParseError unless part.is_a? String
          index += part.length
        end
      end

      @number = @value[index..-1]
      @number ||= String.new
      @length = @number.length
    rescue StandardError
      raise ParseError, "cannot parse #{@value} in given format #{@format}"
    end

    def current_number
      @number.to_i.to_s
    end

    def next_number_with_zeros
      next_number = start_new? ? 1 : (current_number.to_i + 1)
      number_of_zeros = Integer(@length - next_number.to_s.length)
      zeros = ''

      number_of_zeros.times do
        zeros += '0'
      end

      "#{zeros}#{next_number}"
    end

    # Start numbering again from number one?
    def start_new?
      case @by
      when :day
        return true if(new_year? || new_month?)
        new_day?
      when :month
        return true if new_year?
        new_month?
      when :year
        new_year?
      else
        false
      end
    end

    def new_year?
      year_format = (@year.length == 2) ? '%y' : '%Y'
      @year.to_i < @date.strftime(year_format).to_i
    end

    def new_month?
      @month.to_i < @date.strftime('%m').to_i
    end

    def new_day?
      @day.to_i < @date.strftime('%d').to_i
    end
  end
end
