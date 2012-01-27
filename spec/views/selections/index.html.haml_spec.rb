require 'spec_helper'

describe "selections/index" do
  before(:each) do
    assign(:selections, [
      stub_model(Selection,
        :user => nil,
        :song => nil,
        :number_one => false
      ),
      stub_model(Selection,
        :user => nil,
        :song => nil,
        :number_one => false
      )
    ])
  end

end
