require 'spec_helper'

describe SongsController do
  render_views

  before(:all) do
    Fracture.define_selector(:edit_song, "#edit_link")
    Fracture.define_selector(:song_picks, "#picks_title", "#picks_data")
    Fracture.define_selector(:change_picks, "#change_pick")
    Fracture.define_selector(:song_link, "#song_link")
  end

  let(:user) { Factory(:user) }
  let(:user_admin) { Factory(:user_admin) }
  let(:song) { Factory(:song) }

  # admin
  context "logged in as admin" do
    before { sign_in user_admin }

    describe "GET index" do
      context "user not locked" do
        before do
          song
          get :index
        end

        it("assigns all songs as @songs") { assigns(:songs).should eq([song]) }
        it("does not display picks") { response.body.should_not have_fracture(:song_picks) }
        it("allows selecting songs") { response.body.should have_fracture(:change_picks) }
        it("have link to song") { response.body.should have_fracture(:song_link) }
      end

      context "user locked" do
        before do
          user_admin.update_attribute(:locked, true)
          song
          get :index
        end

        it("does display picks") { response.body.should have_fracture(:song_picks) }
        it("not allow changing picks") { response.body.should_not have_fracture(:change_picks) }
      end
    end

    describe "edit" do
      before { get :edit, id: song }

      it { should assign_to(:song).with(song) }
      it { should render_template(:edit) }
    end
    describe "update" do
      context "valid" do
        before do
          Song.any_instance.stub(:valid?).and_return(true)
          put :update, id: song
        end

        it { should assign_to(:song).with(song) }
        it { should redirect_to song_path(song) }
      end
      context "invalid" do
        before do
          song
          Song.any_instance.stub(:valid?).and_return(false)
          put :update, id: song
        end

        it { should assign_to(:song).with(song) }
        it { should render_template(:edit) }
      end
    end
  end

  # user
  context "logged in as user" do
    before { sign_in user }

    describe "GET index" do
      context "user not locked" do
        before do
          song
          get :index
        end

        it("assigns all songs as @songs") { assigns(:songs).should eq([song]) }
        it("does not display picks") { response.body.should_not have_fracture(:song_picks) }
        it("allows selecting songs") { response.body.should have_fracture(:change_picks) }
        it("not have link to song") { response.body.should_not have_fracture(:song_link) }
      end

      context "user locked" do
        before do
          user.update_attribute(:locked, true)
          song
          get :index
        end

        it("does display picks") { response.body.should have_fracture(:song_picks) }
        it("not allow changing picks") { response.body.should_not have_fracture(:change_picks) }
      end
    end

    context "invalid" do
      {show: :get, edit: :get, update: :put, new: :get, create: :post, destroy: :delete}.each do |v, m|
        it "#{m} #{v} should logout" do
          expect { self.send(m, v, id: song) }.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end
end

