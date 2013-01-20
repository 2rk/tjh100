require 'spec_helper'

describe "Users" do

  let(:user) { Factory(:user) }
  let(:user_admin) { Factory(:user_admin) }

  context "sign-up" do
    it "should sign-up" do
      visit new_user_registration_path
      fill_in "Name", with: "Fred"
      fill_in "Email", with: "fred@flintstones.com"
      fill_in "Password", with: "secret"
      fill_in "Password again", with: "secret"

      click_button "Sign up"

      User.last.valid_password?("secret").should be_true
    end
  end

  context "edit" do
    it "changes name" do
      login_as user

      visit edit_user_path(user)
      fill_in "Name", with: "NEW"
      click_button "Save"

      user.reload
      user.name.should == "NEW"
      user.valid_password?("secret").should be_true

    end

    it "changes password" do
      login_as user

      visit edit_user_path(user)

      fill_in "Password", with: "new_secret"
      fill_in "Password confirmation", with: "new_secret"
      click_button "Save"

      user.reload.valid_password?("new_secret").should be_true
    end
  end


  def login_as user, password="secret"
    visit user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password

    click_button "Sign in"

    page.body.should have_content("Signed in successfully.")
  end


  context "lock" do
    context "user" do
      it "should lock own" do
        login_as user
        visit lock_user_path(user)

        user.reload
        user.locked.should be_true
      end
      it "should not lock non-owned" do
        login_as Factory(:user)
        visit lock_user_path(user)
        user.reload
        user.locked.should be_false
      end
    end
    context "admin" do
      it "should lock any" do
        login_as Factory(:user, admin: true)
        visit lock_user_path(user)
        user.reload
        user.locked.should be_true
      end
    end
  end

  context "delete user" do
    it "removes user and there selections" do
      login_as user_admin

      user = Factory(:user)
      song = Factory(:song)
      user.songs = [song]
      selection_id = user.selections.first.id

      visit users_path
      page.find("a[href='#{user_path(user)}']").click

      User.where(id: user.id).should be_empty
      Selection.where(id: selection_id).should be_empty
      Song.where(id: song.id).should_not be_empty
    end
  end

end
