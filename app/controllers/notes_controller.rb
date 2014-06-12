class NotesController < ApplicationController

  def new
    @user = current_user
    @contact = @user.contacts.find(params[:id])
  end


  def create
    @user = current_user
    @contact = @user.contacts.find(params[:id])

    @contact.notes.create(notes_params)

    respond_to do |format|
      format.html {}
      format.js {}
    end

  end


  def update
    @user.contact.find(params[:id]).update(notes_params)
  end


  def destroy
    
  end


  private 

  def notes_params
    params.require(:note).permit(:title, :note)
  end

end
