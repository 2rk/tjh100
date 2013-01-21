class SelectionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = User.find_by_id(params[:user_id])
    if @user
      authorize! :show, @user
      authorize! :read, Selection
      @selections = @user.selections.includes(:song).order("songs.name")
    else
      raise(CanCan::AccessDenied) unless current_user.locked?
      @selections = Selection.joins(:song).group([:song_id, :number_one]).select([:song_id, :number_one]).order(:name)
    end
  end

  def create
    @selection = Song.find(params[:song_id]).selections.create(:user_id => current_user.id)
    redirect_to :back
  end

  def update
    @selection = Selection.find(params[:id])

    @selection.update_attributes(:number_one => true)
    redirect_to :back
  end

  def destroy
    @selection = current_user.selections.find_by_song_id(params[:id])
    @selection.destroy

    redirect_to :back
  end

end
