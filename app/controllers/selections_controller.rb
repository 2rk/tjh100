class SelectionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @selections = @user.selections
  end

  def create
    @selection = Song.find(params[:song_id]).selections.create(:user_id => current_user.id)
    redirect_to :back, notice: 'Selection was successfully created.'
  end

  def update
    @selection = Selection.find(params[:id])

    @selection.update_attributes(:number_one => true)
    redirect_to :back, notice: 'Number One was successfully set.'
  end

  def destroy
    @selection = current_user.selections.find_by_song_id(params[:id])
    @selection.destroy

    redirect_to :back
  end

end
