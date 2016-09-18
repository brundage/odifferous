require "spec_helper"

describe Odifferous do

  it 'responds to :version' do
    expect(Odifferous).to respond_to :version
  end


  it "has a version string" do
    expect(Odifferous::VERSION).to be_a String
  end


  it "has a version number" do
    expect(Odifferous::VERSION).not_to be nil
  end

end
