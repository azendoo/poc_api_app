require 'spec_helper'

describe Task do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @attr = {
      :label => "Foo Task"
    }
  end

  it "should require a label" do
    t = Task.new(@attr.merge(label: nil))
    t.user = user
    t.should_not be_valid
  end

  it "should create a new instance given valid attributes" do
    t = Task.new(@attr)
    t.user = user
    t.should be_valid
  end

  it "should require an author" do
    t = Task.new(@attr)
    t.should_not be_valid
  end

end
