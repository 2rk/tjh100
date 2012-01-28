require 'spec_helper'

describe UsersController do
  before do
    @logged_in_user = Factory(:user)
    sign_in @logged_in_user
  end

  describe "GET index" do
    context "un-nested" do
      it "assigns all users as @users" do
        users = FactoryGirl.create_list(:user, 5)
        get :index
        assigns(:users).should eq(User.all)
      end
    end
    context "nested" do
      it "shows all users with selected song" do
        selection_1 = Factory(:selection)
        selection_2 = Factory(:selection, :song => selection_1.song)
        selection_3 = Factory(:selection)
        get :index, :song_id => selection_2.song_id

        assigns(:song).should == selection_2.song
        assigns(:users).should =~ [selection_1.user, selection_2.user]
      end
    end

  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = Factory(:user)
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, {}
      assigns(:user).should be_a_new(User)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = Factory(:user)
      get :edit, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before { User.any_instance.stub(:valid?).and_return(true) }
      it "creates a new User" do
        expect {
          post :create, {:user => {}}
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => {}}
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        post :create, {:user => {}}
        response.should redirect_to(User.last)
      end
    end

    describe "with invalid params" do
      before { User.any_instance.stub(:valid?).and_return(false) }
      it "assigns a newly created but unsaved user as @user" do
        post :create, {:user => {}}
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, {:user => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before { User.any_instance.stub(:valid?).and_return(true) }
      it "updates the requested user" do
        user = Factory(:user)
        User.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => user.to_param, :user => {'these' => 'params'}}
      end

      it "assigns the requested user as @user" do
        user = Factory(:user)
        put :update, {:id => user.to_param, :user => {}}
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        user = Factory(:user)
        put :update, {:id => user.to_param, :user => {}}
        response.should redirect_to(user)
      end
    end

    describe "with invalid params" do
      before do
        @user = Factory(:user)
        User.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns the user as @user" do
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => @user.to_param, :user => {}}
        assigns(:user).should eq(@user)
      end

      it "re-renders the 'edit' template" do
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => @user.to_param, :user => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = Factory(:user)
      expect {
        delete :destroy, {:id => user.to_param}
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = Factory(:user)
      delete :destroy, {:id => user.to_param}
      response.should redirect_to(users_url)
    end
  end

end
