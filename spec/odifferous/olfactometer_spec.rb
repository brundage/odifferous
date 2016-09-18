require "spec_helper"

describe Odifferous::Olfactometer do

  describe 'binary olfactometers' do

    let(:binary) { Odifferous::Olfactometer.new_binary }

    it 'binary olfactometers have one neutral arm' do
      expect(binary.neutrals.length).to eq(1)
    end

    it 'binary olfactometers have one test arm' do
      expect(binary.tests.length).to eq(1)
    end

    it 'binary olfactometers have one control arm' do
      expect(binary.controls.length).to eq(1)
    end


    it 'returns a binary olfactometer when asked' do
      expect(binary.is_binary?)
    end

  end


end
