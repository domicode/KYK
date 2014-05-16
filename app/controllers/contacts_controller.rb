class ContactsController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @contact = Contact.new
  end

  def create
    @user = User.find(params[:user_id])
    @contact = @user.contacts.create!(contact_params)

    # find if there is any user with that contact email address
    User.all.each do |user|
      if user.email == @contact.email
        @contact.update({ 'user_id' => user.id, 'connected' => "connected" })
        # Add the current user as a contact for the user which is the found contact
        user.contacts.create({
          'new_contact' => true,
          'email' => @user.email,
          'first_name' => @user.first_name,
          'last_name' => @user.last_name,
          })
      end
    end

    redirect_to @user, notice: "contact was created"
  end

  
  def edit
    @user = User.find(params[:user_id])
    @contact = @user.contacts.find(params[:id])
  end

  
  def update
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.contacts.find(params[:id]).update(contact_params)
        format.html { redirect_to @user, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.contacts.find(params[:id]).destroy
    redirect_to @user
  end





  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :street, :postal_code, :city, :country, :email, :connected)
  end


end
