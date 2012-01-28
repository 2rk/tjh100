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

  #describe "GET show" do
  #  it "assigns the requested tweet as @tweet" do
  #    tweet = Tweet.create! valid_attributes
  #    get :show, {:id => tweet.to_param}, valid_session
  #    assigns(:tweet).should eq(tweet)
  #  end
  #end
  #
  #describe "GET new" do
  #  it "assigns a new tweet as @tweet" do
  #    get :new, {}, valid_session
  #    assigns(:tweet).should be_a_new(Tweet)
  #  end
  #end
  #
  #describe "GET edit" do
  #  it "assigns the requested tweet as @tweet" do
  #    tweet = Tweet.create! valid_attributes
  #    get :edit, {:id => tweet.to_param}, valid_session
  #    assigns(:tweet).should eq(tweet)
  #  end
  #end
  #
  #describe "POST create" do
  #  describe "with valid params" do
  #    it "creates a new Tweet" do
  #      expect {
  #        post :create, {:tweet => valid_attributes}, valid_session
  #      }.to change(Tweet, :count).by(1)
  #    end
  #
  #    it "assigns a newly created tweet as @tweet" do
  #      post :create, {:tweet => valid_attributes}, valid_session
  #      assigns(:tweet).should be_a(Tweet)
  #      assigns(:tweet).should be_persisted
  #    end
  #
  #    it "redirects to the created tweet" do
  #      post :create, {:tweet => valid_attributes}, valid_session
  #      response.should redirect_to(Tweet.last)
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns a newly created but unsaved tweet as @tweet" do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Tweet.any_instance.stub(:save).and_return(false)
  #      post :create, {:tweet => {}}, valid_session
  #      assigns(:tweet).should be_a_new(Tweet)
  #    end
  #
  #    it "re-renders the 'new' template" do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Tweet.any_instance.stub(:save).and_return(false)
  #      post :create, {:tweet => {}}, valid_session
  #      response.should render_template("new")
  #    end
  #  end
  #end
  #
  #describe "PUT update" do
  #  describe "with valid params" do
  #    it "updates the requested tweet" do
  #      tweet = Tweet.create! valid_attributes
  #      # Assuming there are no other tweets in the database, this
  #      # specifies that the Tweet created on the previous line
  #      # receives the :update_attributes message with whatever params are
  #      # submitted in the request.
  #      Tweet.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
  #      put :update, {:id => tweet.to_param, :tweet => {'these' => 'params'}}, valid_session
  #    end
  #
  #    it "assigns the requested tweet as @tweet" do
  #      tweet = Tweet.create! valid_attributes
  #      put :update, {:id => tweet.to_param, :tweet => valid_attributes}, valid_session
  #      assigns(:tweet).should eq(tweet)
  #    end
  #
  #    it "redirects to the tweet" do
  #      tweet = Tweet.create! valid_attributes
  #      put :update, {:id => tweet.to_param, :tweet => valid_attributes}, valid_session
  #      response.should redirect_to(tweet)
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns the tweet as @tweet" do
  #      tweet = Tweet.create! valid_attributes
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Tweet.any_instance.stub(:save).and_return(false)
  #      put :update, {:id => tweet.to_param, :tweet => {}}, valid_session
  #      assigns(:tweet).should eq(tweet)
  #    end
  #
  #    it "re-renders the 'edit' template" do
  #      tweet = Tweet.create! valid_attributes
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Tweet.any_instance.stub(:save).and_return(false)
  #      put :update, {:id => tweet.to_param, :tweet => {}}, valid_session
  #      response.should render_template("edit")
  #    end
  #  end
  #end
  #
  #describe "DELETE destroy" do
  #  it "destroys the requested tweet" do
  #    tweet = Tweet.create! valid_attributes
  #    expect {
  #      delete :destroy, {:id => tweet.to_param}, valid_session
  #    }.to change(Tweet, :count).by(-1)
  #  end
  #
  #  it "redirects to the tweets list" do
  #    tweet = Tweet.create! valid_attributes
  #    delete :destroy, {:id => tweet.to_param}, valid_session
  #    response.should redirect_to(tweets_url)
  #  end
  #end
  #
end
