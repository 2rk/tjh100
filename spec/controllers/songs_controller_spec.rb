require 'spec_helper'

describe SongsController do
  render_views

  before(:all) do
    Fracture.define_selector(:edit_song, "#edit_link")
    Fracture.define_selector(:song_picks, "#picks_title", "#picks_data")

  end

  let(:user) { Factory(:user) }
  let(:user_admin) { Factory(:user_admin) }
  let(:song) { Factory(:song) }

  context "logged in as admin" do
    before { sign_in user_admin }

    describe ".show" do
      before { get "show", id: song }
      it("should display edit") { response.body.should have_fracture(:edit_song) }
    end

  end

  # user
  context "logged in as user" do
    before { sign_in user }

    def valid_attributes
      FactoryGirl.build(:song).attributes
    end

    describe "GET index" do
      context "user not locked" do
        before do
          @song = FactoryGirl.create_list(:song, 2)
          get :index
        end

        it("assigns all songs as @songs") { assigns(:songs).should eq(@song) }
        it("does not display picks") { response.body.should_not have_fracture(:song_picks)}
      end

      context "user locked" do
        before do
          user.update_attribute(:locked, true)
          song = FactoryGirl.create_list(:song, 2)
          get :index
        end

        it("does display picks") { response.body.should have_fracture(:song_picks)}
      end
    end

    describe "GET show" do
      before { get :show, {:id => song} }
      it("assigns the requested song as @song") { assigns(:song).should eq(song) }
      it("should display edit") { response.body.should_not have_fracture(:edit_song) }

    end

    describe "GET new" do
      it "assigns a new song as @song" do
        get :new
        assigns(:song).should be_a_new(Song)
      end
    end

    describe "GET edit" do
      it "assigns the requested song as @song" do
        song = Factory(:song)
        get :edit, {:id => song}
        assigns(:song).should eq(song)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Song" do
          expect {
            post :create, {:song => valid_attributes}
          }.to change(Song, :count).by(1)
        end

        it "assigns a newly created song as @song" do
          post :create, {:song => valid_attributes}
          assigns(:song).should be_a(Song)
          assigns(:song).should be_persisted
        end

        it "redirects to the created song" do
          post :create, {:song => valid_attributes}
          response.should redirect_to(Song.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved song as @song" do
          # Trigger the behavior that occurs when invalid params are submitted
          Song.any_instance.stub(:save).and_return(false)
          post :create, {:song => {}}
          assigns(:song).should be_a_new(Song)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Song.any_instance.stub(:save).and_return(false)
          post :create, {:song => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested song" do
          song = Song.create! valid_attributes
          # Assuming there are no other songs in the database, this
          # specifies that the Song created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Song.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => song.to_param, :song => {'these' => 'params'}}
        end

        it "assigns the requested song as @song" do
          song = Song.create! valid_attributes
          put :update, {:id => song.to_param, :song => valid_attributes}
          assigns(:song).should eq(song)
        end

        it "redirects to the song" do
          song = Song.create! valid_attributes
          put :update, {:id => song.to_param, :song => valid_attributes}
          response.should redirect_to(song)
        end
      end

      describe "with invalid params" do
        it "assigns the song as @song" do
          song = Song.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Song.any_instance.stub(:save).and_return(false)
          put :update, {:id => song.to_param, :song => {}}
          assigns(:song).should eq(song)
        end

        it "re-renders the 'edit' template" do
          song = Song.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Song.any_instance.stub(:save).and_return(false)
          put :update, {:id => song.to_param, :song => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested song" do
        song = Song.create! valid_attributes
        expect {
          delete :destroy, {:id => song.to_param}
        }.to change(Song, :count).by(-1)
      end

      it "redirects to the songs list" do
        song = Song.create! valid_attributes
        delete :destroy, {:id => song.to_param}
        response.should redirect_to(songs_url)
      end
    end
  end
end

