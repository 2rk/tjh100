class SongsController < ApplicationController
  before_filter :authenticate_user!

  helper_method :sort_column, :sort_direction

  def index
    @search = Song.search(params[:search])
    @songs = @search.page(params[:page]).order(sort_column + " " + sort_direction).per(20)
    @song_ids = current_user.selections.map &:song_id
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def edit
    @song = Song.find(params[:id])
  end

  def create
    @song = Song.new(params[:song])

    if @song.save
      redirect_to @song, notice: 'Song was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @song = Song.find(params[:id])

    if @song.update_attributes(params[:song])
      redirect_to @song, notice: 'Song was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    redirect_to songs_url
  end

  private

  def sort_column
    Song.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
