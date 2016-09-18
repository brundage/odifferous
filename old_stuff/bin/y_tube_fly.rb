class YTubeFly

  attr_reader :date, :flynum, :gender

  CONTROL = "C"
  NEUTRAL = "N"
  TEST    = "T"

  HEADERS = %w( date
                gender
                flynum
                initial_place
                initial_place_binary
                final_place
                final_place_binary
                time_spent_in_N
                time_spent_in_C
                time_spent_in_T
                favors_T?
                favors_T_binary? )

  class << self

    def headers
      HEADERS.collect { |h| h.to_s }
    end

  end

  class YTubeChoice
    class UnrecognizedChoice < RuntimeError; end

    attr :place, true
    attr_reader :timestamp
    def initialize(str)
      parse_choice(str)
    end
    def place_binary
      case @place.upcase
      when YTubeFly::CONTROL
        0
      when YTubeFly::TEST
        1
      else
        raise YTubeFly::YTubeChoice::UnrecognizedChoice, "Can't convert place to binary (#{@place})"
      end
    end
    def seconds
      time = @timestamp.split(":")
      time[0].to_i * 60 + time[1].to_i
    end
    def time_between(other)
      return seconds if other.nil?
      (seconds - other.seconds).abs
    end
  private
    def parse_choice(str)
      arr = /^\s*(#{CONTROL}|#{TEST}|#{NEUTRAL}):?\s*([0-9:]+)/i.match(str).captures
      @place = arr[0].upcase
      @timestamp = arr[1]
    rescue NoMethodError
      raise UnrecognizedChoice, str
    end
  end # End class YTubeChoice


  def dump
    HEADERS.collect { |method| send(method) }
  end

  def favors_C?
    ! equal_time && time_spent_in_C > time_spent_in_T
  end

  def favors_T?
    ! ( equal_time || favors_C? )
  end

  def favors_T_binary?
    favors_T? ? 1 : 0
  end

  def final_place
    first_non_neutral(@choices.reverse)
  end

  def final_place_binary
    choice_to_binary(final_place)
  end

  def initial_place
    first_non_neutral(@choices)
  end

  def initial_place_binary
    choice_to_binary(initial_place)
  end

  def initialize(args={})
    args = default_args.merge(args)
    @date      = args["date"]
    @flynum    = args["number"]
    @gender    = args["gender"]
    @stop_time = args["stop_time"]
    parse_choices( args["data"] )
  end

  def method_missing(m,*a,&b)
    case m.to_s
    when /time_spent_in_([tcn])/i
      time_spent_in($1)
    else
      super
    end
  end

  def parse_choices(choices)
    @choices = [ YTubeChoice.new("#{NEUTRAL}: 0:00"),
                 YTubeChoice.new("#{NEUTRAL}: #{@stop_time}") ]
    choices.compact.each do |c|
      begin
        new_choice = YTubeChoice.new(c) 
      rescue YTubeFly::YTubeChoice::UnrecognizedChoice
        raise YTubeFly::YTubeChoice::UnrecognizedChoice, "Unrecognized choice (#{c}) at column #{choices.index(c)}"
      end
      @choices.insert( -2, new_choice )
      @choices[-1].place = new_choice.place
    end
    @times  = Hash.new
  end

private

  def choice_to_binary(choice)
    choice.upcase!
    case choice
    when CONTROL
      0
    when TEST
      1
    else
      raise YTubeFly::YTubeChoice::UnrecognizedChoice, "Unrecognized choice (#{choice})"
    end
  end

  def default_args
    { "stop_time" => "5:00"  }
  end

  def first_non_neutral(arr)
    arr.select { |c| c.place !~ /^#{NEUTRAL}/i }.first.place
  rescue NoMethodError  # arr.select returns nil
    ""
  end

  def equal_time
    time_spent_in_C == time_spent_in_T
  end

  def time_spent_in(place)
    place.upcase!
    return @times[place] unless @times[place].nil?  # Memoization
    @times[place] = 0
    curr_choice = @choices[0]
    @choices[1..@choices.length].each do |next_choice|
      if curr_choice.place == place
        @times[place] += curr_choice.time_between(next_choice)
      end
      curr_choice = next_choice
    end
    @times[place]
  end

end
