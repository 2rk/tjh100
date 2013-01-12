require 'spec_helper'

describe "Users" do

  let(:user) { Factory(:user)}

  context "sign-up" do
    it "should sign-up" do
      visit new_user_registration_path
      fill_in "Name", with: "Fred"
      fill_in "Email", with: "fred@flintstones.com"
      fill_in "Password", with: "secret"
      fill_in "Password confirmation", with: "secret"

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

end
