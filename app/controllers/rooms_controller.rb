class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :index]

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(room_params)
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
      @entries.each do |entry|
        if entry.user_id != current_user.id
          @dmUser = User.find(entry.user_id)
        end
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def index
    @currentEntries = current_user.entries
    myRoomIds = []
    @currentEntries.each do |entry|
      myRoomIds << entry.room_id
    end
    @anotherEntries = Entry.where(room_id: myRoomIds).where('user_id != ?', current_user.id)
  end

  private

  def room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end
end
