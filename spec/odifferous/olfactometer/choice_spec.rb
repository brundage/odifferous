require "spec_helper"

describe Odifferous::Olfactometer::Choice do

  let(:choice) { described_class.new arm: arm,
                                     olfactometer: olfactometer,
                                     subject: subject,
                                     timestamp: timestamp
               }
  let(:arm) { Odifferous::Olfactometer::Arm.new }
  let(:olfactometer) { Odifferous::Olfactometer.new }
  let(:subject) { Odifferous::TestSubject.new }
  let(:timestamp) { Time.now }

end
