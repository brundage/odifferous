module Odifferous
  class Olfactometer
    class Arm
      attr_reader :control, :name, :neutral, :olfactometer


      def initialize(args)
        self.control      = args[:control] || false
        self.name         = args[:name]
        self.neutral      = args[:neutral] || false
        self.olfactometer = args[:olfactometer]
        if self.name.nil? || self.name == ""
          raise RuntimeError, "Arm name can't be blank"
        end
        unless self.olfactometer.is_a?(Olfactometer)
          raise RuntimeError, "Could not use that olfactometer: #{self.olfactometer}"
        end
        if !!self.control != self.control
          raise RuntimeError, "args[:control] for #{self.name} must be true or false"
        end
        if !!self.neutral != self.neutral
          raise RuntimeError, "args[:neutral] for #{self.name} must be true or false"
        end
        if self.control && self.neutral
          raise RuntimeError, "Arm #{self.name} is both control and neutral."
        end
      end


      def ==(other)
        name == other.name && is_same_role(other)
      end


      def is_control?
        control
      end
      alias_method :control?, :is_control?


      def is_neutral?
        neutral
      end
      alias_method :neutral?, :is_neutral?


      def is_same_role(other)
        ( is_control? && other.is_control? ) ||
        ( is_neutral? && other.is_neutral? ) ||
        ( is_test?    && other.is_test? )
      end


      def is_test?
        ! (control || neutral)
      end
      alias_method :test?, :is_test?


    private

      def control=(c); @control = c; end
      def name=(c); @name = c; end
      def neutral=(c); @neutral = c; end
      def olfactometer=(c); @olfactometer = c; end

    end
  end
end
