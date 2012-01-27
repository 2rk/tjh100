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

  #def update
  #  @selection = Selection.find(params[:id])
  #
  #  respond_to do |format|
  #    if @selection.update_attributes(params[:selection])
  #      redirect_to :back, notice: 'Selection was successfully updated.'
  #    end
  #  end
  #end

  def destroy
    @selection = current_user.selections.find_by_song_id(params[:id])
    @selection.destroy

    redirect_to :back
  end

end
