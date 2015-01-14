class PartiesController < ApplicationController
  def index
    @parties = Party.all
  end

  def show
    @party = Party.find(params[:id])
  end

  def new
    @party = Party.new
  end

  def edit
    @party = Party.find(params[:id])
  end

  def create
    @party = Party.new(params[:party])

      if @party.save
        redirect_to @party, notice: 'Party was successfully created.'
      else
        render action: "new"
      end
  end

  def update
    @party = Party.find(params[:id])

      if @party.update_attributes(params[:party])
     redirect_to @party, notice: 'Party was successfully updated.'
      else
         render action: "edit"
      end
  end

  def destroy
    @party = Party.find(params[:id])
    @party.destroy

      redirect_to parties_url
  end
end
