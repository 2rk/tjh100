class GuestsController < ApplicationController

  def index
    @party = Party.find_by_id(params[:party_id])
    @users = User.all - @party.users
    @guest = true
    render 'users/_index'
  end

  def create
    @party = Party.find_by_id(params[:party_id])
    @guest = Guest.create(user_id: params[:user_id], party_id: @party.id)

    redirect_to party_guests_path(@party), notice: 'Guest was successfully created.'
  end

  def destroy
    @party = Party.find_by_id(params[:party_id])
    @guest = @party.guests.find_by_user_id(params[:id])
    @guest.destroy

    redirect_to party_users_path(@party)
  end
end
