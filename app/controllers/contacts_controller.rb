class ContactsController < ApplicationController


  def create
    @user = User.find(params[:user_id])
    @contact = @user.contacts.create!(comment_params)
    redirect_to @user, notice: "contact was created"
  end



  private

  def comment_params
    params.require(:contact).permit(:first_name, :last_name, :address, :postal_code, :city)
  end


end
