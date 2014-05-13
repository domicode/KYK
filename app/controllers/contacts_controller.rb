class ContactsController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @contact = Contact.new(:user_id=>@user.id)
  end

  def create
    @user = User.find(params[:user_id])
    @contact = @user.contacts.create!(contact_params)
    redirect_to @user, notice: "contact was created"
  end

  
  def edit
    @user = User.find(params[:user_id])
    @contact = @user.contacts.first
  end

  
  def update
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.contacts.first.update(contact_params)
        format.html { redirect_to @user, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.contact.errors, status: :unprocessable_entity }
      end
    end
  end





  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :street, :postal_code, :city, :country)
  end


end
