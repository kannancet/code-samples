class Api::UsersController < Api::BaseController
  protect_from_forgery with: :null_session
  private

  def user_params
  	params[:user][:birth_date] = Date.strptime(params[:user][:birth_date], "%m/%d/%Y")
    params_filtered = params.require(:user).permit(:name, :gender, :country, :birth_date, :email, :password, :password_confirmation)
  end

  def query_params
    params.permit(:name, :gender, :country, :birth_date, :email, :password, :password_confirmation)
  end

end
