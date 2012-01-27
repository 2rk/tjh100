class SelectionsController < ApplicationController
  before_filter :authenticate_user!
  # GET /selections
  # GET /selections.json
  def index
    @user = User.find(params[:user_id])
    @selections = @user.selections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @selections }
    end
  end

  # GET /selections/1
  # GET /selections/1.json
  def show
    @selection = Selection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @selection }
    end
  end

  # GET /selections/new
  # GET /selections/new.json
  def new
    @selection = Selection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @selection }
    end
  end

  # GET /selections/1/edit
  def edit
    @selection = Selection.find(params[:id])
  end

  # POST /selections
  # POST /selections.json
  def create
    @selection = Song.find(params[:song_id]).selections.create(:user_id => current_user)
    redirect_to :back, notice: 'Selection was successfully created.'
  end

  # PUT /selections/1
  # PUT /selections/1.json
  def update
    @selection = Selection.find(params[:id])

    respond_to do |format|
      if @selection.update_attributes(params[:selection])
        format.html { redirect_to @selection, notice: 'Selection was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /selections/1
  # DELETE /selections/1.json
  def destroy
    @selection = Selection.find(params[:id])
    @selection.destroy

    redirect_to :back
  end
end
