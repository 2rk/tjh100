require 'spec_helper'

describe TweetsController do
  before do
    @logged_in_user = Factory(:user)
    sign_in @logged_in_user
  end
  describe "GET index" do
    it "assigns all tweets as @tweets in order of position" do
      Factory(:tweet, position: 20)
      FactoryGirl.create_list(:tweet, 2)
      get :index
      assigns(:tweets).should == Tweet.all(order: :position)
    end
  end

  describe "GET new" do
    it "trigger a tweet check" do
      Twitter.stub(:user_timeline).and_return([Twitter::Status.new("text" => "#6 @LanaDelRey - 'Video Games' #Hottest100", "id" => 20)])

      expect {
        get :new
      }.to change(Tweet, :count).by(1)
    end
  end
end
