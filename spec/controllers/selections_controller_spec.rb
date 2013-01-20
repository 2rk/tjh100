require 'spec_helper'

describe SelectionsController do

  render_views

  before(:all) do
    Fracture.define_selector(:user_change_picks, "#remove_pick", "#set_number_one")
    Fracture.define_selector(:picks, "#picks_heading", "#picks_data")
    Fracture.define_selector(:user_heading, "#user_heading")
    Fracture.define_selector(:all_selections_menu, "#all_selections_menu")
  end

  # User
  context "logged in as user" do
    before do
      @logged_in_user = Factory(:user)
      sign_in @logged_in_user
      @request.env["HTTP_REFERER"] = root_url
    end


    describe "GET index" do
      context "unnested" do
        it "does not display list when unlocked" do
          user_2 = Factory(:user)
          @selections_1 = FactoryGirl.create_list(:selection, 2, user: @logged_in_user)
          selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
          expect { get :index }.to raise_error(CanCan::AccessDenied)
        end
        it "does not display list when locked" do
          user_2 = Factory(:user)
          @selections_1 = FactoryGirl.create_list(:selection, 2, user: @logged_in_user)
          selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
          @logged_in_user.update_attribute(:locked, true)
          get :index
          assigns(:selections).should =~([selections_2, @selections_1].flatten)
          response.body.should_not have_fracture(:user_heading)
        end
      end
      context "nested" do
        context "owned" do
          context "unlocked" do
            before do
              user_2 = Factory(:user)
              @selections_1 = FactoryGirl.create_list(:selection, 2, user: @logged_in_user)
              selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
              get :index, :user_id => @logged_in_user
            end
            it("assigns all selections as @selections") { assigns(:selections).should eq(@selections_1) }
            it { response.body.should have_fracture(:user_change_picks) }
            it { response.body.should_not have_fracture(:picks) }
            it { response.body.should have_fracture(:user_heading) }
            it { response.body.should_not have_fracture(:all_selections_menu) }
          end
          context "locked" do
            before do
              user_2 = Factory(:user)
              @selections_1 = FactoryGirl.create_list(:selection, 2, user: @logged_in_user)
              selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
              @logged_in_user.update_attribute(:locked, true)
              get :index, :user_id => @logged_in_user
            end
            it("assigns all selections as @selections") { assigns(:selections).should eq(@selections_1) }
            it { response.body.should_not have_fracture(:user_change_picks) }
            it { response.body.should have_fracture(:picks) }
            it { response.body.should have_fracture(:all_selections_menu) }
          end
        end
        context "not owned" do
          it "not display when user not locked" do
            user_2 = Factory(:user)
            selections_1 = FactoryGirl.create_list(:selection, 2, user: @logged_in_user)
            selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
            expect { get :index, :user_id => user_2 }.to raise_error(CanCan::AccessDenied)
          end

          it "display when user locked" do
            @logged_in_user.update_attribute(:locked, true)
            user_2 = Factory(:user)
            selections_1 = FactoryGirl.create_list(:selection, 2, user: @logged_in_user)
            selections_2 = FactoryGirl.create_list(:selection, 3, user: user_2)
            get :index, :user_id => user_2
            assigns(:selections).should eq(selections_2)
            response.body.should have_fracture(:picks)

          end
        end
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
end
