class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @song = Song.find_by_id(params[:song_id])
    @party = Party.find_by_id(params[:party_id])
    case

      when @song
        @users = @song.users.order(:name)
      when @party
        @users = @party.users.order(:name)
      else
        @users = User.order(:score).reverse
    end
  end



  def show
    @user = User.find(params[:id])
    @selections = @user.selections
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank? ? @user.update_without_password(params[:user]) : @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end

  def lock
    @user = User.find(params[:id])

    if current_user.admin?
      @user.update_attribute(:locked, true)
      redirect_to user_selections_path(@user)
    else
      if current_user == @user
        @user.update_attribute(:locked, true)
        redirect_to user_selections_path(@user)
      else
        redirect_to new_user_session_path
      end
    end
  end
end
