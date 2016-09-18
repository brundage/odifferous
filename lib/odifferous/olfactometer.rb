module Odifferous
  class Olfactometer

    autoload :Arm, 'odifferous/olfactometer/arm'
    autoload :Choice, 'odifferous/olfactometer/choice'

    attr_accessor :arms, :name


    class << self

      def new_binary(args={})
        olfactometer = new(args)
        olfactometer.arms << Arm.new( :name => :neutral, :neutral => true, :olfactometer => olfactometer )
        olfactometer.arms << Arm.new( :name => :control, :control => true, :olfactometer => olfactometer )
        olfactometer.arms << Arm.new( :name => :test, :olfactometer => olfactometer )
        olfactometer
      end

    end


    def initialize(attrs={})
      @arms = []
      @name = attrs["name"]
    end


    def binary?
      @arms.length == 3 && controls.length == 1 && tests.length == 1
    end
    alias_method :is_binary?, :binary?


    def control
      if is_binary?
      else
      end
    end


    def controls
      @arms.select { |arm| arm.is_control? }
    end


    def neutrals
      @arms.select { |arm| arm.is_neutral? }
    end


    def tests
      @arms.select { |arm| arm.is_test? }
    end

  end
end
