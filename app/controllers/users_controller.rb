class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @person = Person.new
    @person.build_contact_info
    @user = User.new
    @user.person = @person
  end

  def create
    @user = User.new(createuser_params)

    # if (User.exists?(:username => @user.username)) #pre-check
      # if (@user.errors == nil)
        # @user.errors = ActiveModel::Errors.new(@user)
      # end
      # @user.errors.add(:username, "The username you've chosen is already in use.  Please choose a different username.")
    # end

    begin
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Makevention!"
        redirect_to :controller =>  'people', :action => 'edit', :id => @user.person.id
      else
        render 'new'
      end
    rescue ActiveRecord::RecordNotUnique #insurance
      if (@user.errors == nil)
        @user.errors = ActiveModel::Errors.new(@user)
      end
      @user.errors.add(:username, "The username you've chosen is already in use.  Please choose a different username.")
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

end

private
def createuser_params
  params.require(:user).permit(:username, :password, :password_confirmation, person_attributes: [:first_name, :last_name, contact_info_attributes: [:email]])
end