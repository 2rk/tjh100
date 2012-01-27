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

  #describe "GET show" do
  #  it "assigns the requested selection as @selection" do
  #    selection = Factory(:selection)
  #    get :show, {:id => selection.to_param}
  #    assigns(:selection).should eq(selection)
  #  end
  #end
  #
  #describe "GET new" do
  #  it "assigns a new selection as @selection" do
  #    get :new, {}
  #    assigns(:selection).should be_a_new(Selection)
  #  end
  #end
  #
  #describe "GET edit" do
  #  it "assigns the requested selection as @selection" do
  #    selection = Selection.create!
  #    get :edit, {:id => selection.to_param}
  #    assigns(:selection).should eq(selection)
  #  end
  #end
  #
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

  #describe "PUT update" do
  #  describe "with valid params" do
  #    it "updates the requested selection" do
  #      selection = Selection.create! valid_attributes
  #      # Assuming there are no other selections in the database, this
  #      # specifies that the Selection created on the previous line
  #      # receives the :update_attributes message with whatever params are
  #      # submitted in the request.
  #      Selection.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
  #      put :update, {:id => selection.to_param, :selection => {'these' => 'params'}}
  #    end
  #
  #    it "assigns the requested selection as @selection" do
  #      selection = Selection.create! valid_attributes
  #      put :update, {:id => selection.to_param, :selection => valid_attributes}
  #      assigns(:selection).should eq(selection)
  #    end
  #
  #    it "redirects to the selection" do
  #      selection = Selection.create! valid_attributes
  #      put :update, {:id => selection.to_param, :selection => valid_attributes}
  #      response.should redirect_to(selection)
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns the selection as @selection" do
  #      selection = Selection.create! valid_attributes
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Selection.any_instance.stub(:save).and_return(false)
  #      put :update, {:id => selection.to_param, :selection => {}}
  #      assigns(:selection).should eq(selection)
  #    end
  #
  #    it "re-renders the 'edit' template" do
  #      selection = Selection.create! valid_attributes
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Selection.any_instance.stub(:save).and_return(false)
  #      put :update, {:id => selection.to_param, :selection => {}}
  #      response.should render_template("edit")
  #    end
  #  end
  #end

  describe "DELETE destroy" do
    it "destroys the requested selection" do
      selection = Factory(:selection)
      expect {
        delete :destroy, {:id => selection, :song_id => selection.song}
      }.to change(Selection, :count).by(-1)
    end

    it "redirects to the selections list" do
      selection = Factory(:selection)
      delete :destroy, {:id => selection, :song_id => selection.song}
      response.should redirect_to(:back)
    end
  end
end
