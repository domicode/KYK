class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :require_login, :except => [:not_authenticated]
  skip_before_filter :require_login, only: [:index, :new, :create]
  before_filter :get_id

  def index
    if current_user
      redirect_to user_path(current_user.id)
    else
      redirect_to login_path
    end
  end

  def show
    @user = User.find(params[:id])

    if params[:search] && params[:search] != ""
      @contacts = @user.contacts.where(first_name: params[:search])
    elsif params[:search_tags] && params[:search_tags] != ""
      search_tags = Array.new
      params[:search_tags].split(',').each do |tag|
        search_tags.push(tag.strip) unless search_tags.include?(tag)
      end

      @contacts = @user.contacts.where(:tags.in => search_tags)
    else
      @contacts = @user.contacts.asc(:last_name)
    end

    @new_contacts = @user.contacts.where(new_contact: true)
        
    respond_to do |format|
      format.js {}
      format.html {}
    end

    select_push_fields

  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save

        connect_embedded_contact
        auto_login(@user)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      # if password != empty use user_params otherwise edit_params
      if params[:user][:password].blank? 
        params = edit_user_params
      else
        params = user_params
      end
      if @user.update(params)

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { }
    end
  end


  # This method is for adding a new contact to the user as an embedded document
  def add_contact
    user = User.find(params[:user_id])
    @contacts = user.contacts.where(id: params[:contact_id])
    @contacts.update({ 'new_contact' => nil, 'connected' => "connected" })

    respond_to do |format|
      # format.json { render :json => @contact }
      format.js {}
    end
  end


  def select_push_fields
    @user = User.find(params[:id])
    @blacklist = ["salt", "crypted_password", "_id", "coordinates", "contacts", 
                  "updated_at", "created_at", "remember_me_token", "remember_me_token_expires_at"]
    @pushcontacts = @user.contacts.where(connected: "connected")
  end

  def push
    @keys = []
    @contacts = []
    params.each do |key, value|
      @keys.push(key) if value.to_s.to_i == 1
      @contacts.push(key) if value.to_s.to_i == 2
    end

    current_user.update_contacts_attributes(@keys, @contacts)

    redirect_to current_user
  end


  def filter_push_contacts
    @user = current_user
    tag = params[:tag]
    if tag == "url"
      @pushcontacts = @user.contacts.where(connected: "connected").asc(:last_name)
    else
      @pushcontacts = @user.contacts.where(tags: tag, connected: "connected").asc(:last_name)
    end
    
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end



  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :street, :postal_code, :city, :country, :email, :coordinates, :password, :password_confirmation)
  end

  def edit_user_params
    params.require(:user).permit(:first_name, :last_name, :street, :postal_code, :city, :country, :email, :coordinates)
  end

  def not_authenticated
    redirect_to root_path, :alert => "Please login first"
  end

  def connect_embedded_contact

    # find all embedded contacts document with that user email
    User.all.each do |user|
      user.contacts.each do |contact|
        if contact.email == @user.email
          contact.update({ 
           'user_id' => @user.id,
           'connected' => "connected",
           })
          @user.contacts.create({
            'new_contact' => true,
            'email' => user.email,
            'first_name' => user.first_name,
            'last_name' => user.last_name,
            'user_id' => user.id,
            })
        end
      end
    end
  end

  # As users are not called by +id+ but by +login+ here is a function
  # that converts a params[:id] containing an alphanumeric login to a 
  # params[:id] with a numeric id
  def get_id
    params[:id] = current_user.id unless current_user.nil?
  end


end
