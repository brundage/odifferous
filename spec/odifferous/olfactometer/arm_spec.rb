require "spec_helper"

describe Odifferous::Olfactometer::Arm do

  let(:arm) { described_class.new control: control,
                                  name: name,
                                  neutral: neutral,
                                  olfactometer: olfactometer
            }
  let(:control) { false }
  let(:name) { 'an arm' }
  let(:neutral) { false }
  let(:olfactometer) { Odifferous::Olfactometer.new }

  let(:other) { described_class.new control: other_control,
                                    name: other_name,
                                    neutral: other_neutral,
                                    olfactometer: other_olfactometer
              }
  let(:other_control) { control }
  let(:other_name) { name }
  let(:other_neutral) { neutral }
  let(:other_olfactometer) { olfactometer }


  shared_examples_for :invalid_new do
    it 'throws a runtime error' do
      expect{ arm }.to raise_error(RuntimeError)
    end
  end


  shared_examples_for :comparing_different do
    it 'compares correctly' do
      expect(arm.is_same_role(other)).to eq(false)
    end
  end


  shared_examples_for :comparing_same do
    it 'compares correctly' do
      expect(arm.is_same_role(other)).to eq(true)
    end
  end


  it 'spec mocks a valid arm' do
    expect { arm }.not_to raise_error
  end


  context 'with a nil name' do
    let(:name) { nil }
    it_behaves_like :invalid_new
  end


  context 'with a blank name' do
    let(:name) { "" }
    it_behaves_like :invalid_new
  end


  context 'with both control & neutral' do
    let(:control) { true }
    let(:neutral) { true }
    it_behaves_like :invalid_new
  end


  context 'with a invalid neutral' do
    let(:neutral) { :blark }
    it_behaves_like :invalid_new
  end


  context 'with a invalid control' do
    let(:control) { :blark }
    it_behaves_like :invalid_new
  end


  context 'comparing the same arm' do
    let(:other) { arm }

    context 'test' do
      let(:test) { true }
      it 'is a test arm' do
        expect(arm.test?)
      end
    end


    context 'neutral' do
      let(:neutral) { true }
      it 'is a neutral arm' do
        expect(arm.neutral?)
      end
    end


    context 'control' do
      let(:control) { true }
      it 'is a control arm' do
        expect(arm.control?)
      end
    end


    context 'comparing' do

      context 'when they are the same' do
        for config in [ [true, false],
                        [false, true],
                        [false, false] ] do
          let(:control) { config[0] }
          let(:neutral) { config[1] }
          it_behaves_like :comparing_same
        end
      end

    end

  end
end
