module Odifferous
  class TestSubject

    attr :choices
    attr_reader :details, :id


    def initialize(args={})
      self.id = args[:id]
      raise RuntimeError, "Blank test subject id" if self.id.nil? || self.id == ""
      self.choices = []
      self.details = args[:details]
    end


    def binary?
      choices.all? { |c| c.olfactometer.binary? }
    end


    def equal_time?
    end


    def time_spent_in(arm)
      return 0 if choices.length == 0
      if choices.length == 1
        return choices[0].place == arm ? choices[0].seconds : 0
      end

      prev_choice = choices[0]
      choices[1..choices.length].inject(0) do |time,choice|
        if prev_choice.arm == arm
          time += choice.time_between(prev_choice)
        end
        prev_choice = choice
        time
      end
    end


  private

    def details=(d); @details = d; end
    def id=(d); @id = d; end

  end
end
