module Odifferous
  class Olfactometer
    class Choice

      class UnrecognizedChoice < RuntimeError; end

      attr_reader :arm, :olfactometer, :timestamp

      def initialize(args)
        self.olfactometer = args[:olfactometer]
        unless self.olfactometer.is_a? Olfactometer
          raise RuntimeError, "Could not use that olfactometer: #{self.olfactometer}"
        end
        self.subject = args[:subject]
        unless self.subject.is_a? TestSubject
          raise RuntimeError, "This choice needs a test subject"
        end
        self.arm = args[:arm]
        unless self.arm.is_a? Arm
          raise RuntimeError, "This choice needs an arm"
        end
        self.timestamp = args[:timestamp]
        if self.timestamp.nil? || self.timestamp == ""
          raise RuntimeError, "Missing timestamp"
        end
      end


      def arm_binary
        if olfactometer.binary?
          case arm
          when olfactometer.control
            0
          when olfactometer.test
            1
          else
            raise UnrecognizedChoice, "Can't convert arm (#{arm}) to binary"
          end
        else
          raise RuntimeError, "Olfactometer is not dual-choice"
        end
      end


      def seconds
        time = timestamp.split(":")
        time[0].to_i * 60 + time[1].to_i
      end


      def time_between(other)
        return seconds if other.nil?
        (seconds - other.seconds).abs
      end

    private

      def arm=(a); @arm = a; end
      def olfactometer=(a); @olfactometer = a; end
      def subject=(a); @subject = a; end
      def timestamp=(a); @timestamp = a; end

    end
  end
end
