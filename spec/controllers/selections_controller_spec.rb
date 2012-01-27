require 'spec_helper'

describe SelectionsController do

  before do
    @logged_in_user = Factory(:user)
    sign_in @logged_in_user
    @request.env["HTTP_REFERER"] = root_url

  end

  describe "GET index" do
    it "assigns all selections as @selections" do
      user_1 = Factory(:user)
      user_2 = Factory(:user)
      selections_1 = FactoryGirl.create_list(:selection, 2, user: user_1)
      selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
      get :index, :user_id => user_1
      assigns(:selections).should eq(selections_1)
    end
  end

  describe "POST create" do
    before do
      @song = Factory(:song)
      post :create, song_id: @song
    end

    it("should persist") { assigns(:selection).should be_persisted }
    it("sets current user") { assigns(:selection).user.should == @logged_in_user }
    it("sets posted song") { assigns(:selection).song.should == @song }
    it("redirects to the created selection") { response.should redirect_to(:back) }
  end

  describe "PUT update" do
    before do
      @user_10 = Factory(:user)
      @selection_11 = Factory(:selection, user: @user_10, number_one: true)
      @selection_12 = Factory(:selection, user: @user_10)

      put :update, {:id => @selection_11}
    end

    it("updates the requested selection") { @selection_11.reload.number_one.should be_true }
    it("redirects to the selection") { response.should redirect_to(:back) }
  end

  describe "DELETE destroy" do
    it "destroys the requested selection" do
      selection = Factory(:selection, :user => @logged_in_user)
      expect {
        delete :destroy, {:id => selection.song_id}
      }.to change(Selection, :count).by(-1)
    end

    it "redirects to the selections list" do
      selection = Factory(:selection, :user => @logged_in_user)
      delete :destroy, {:id => selection.song_id}
      response.should redirect_to(:back)
    end
  end
end
