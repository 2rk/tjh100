class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @song = Song.find_by_id(params[:song_id])
    if @song
      @users = @song.users.order(:name)
    else
      @users = User.order(:name).all
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

    if @user.update_attributes(params[:user])
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
end
