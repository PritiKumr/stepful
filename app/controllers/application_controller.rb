class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :all_users

  def current_user
    @current_user ||= begin
      if params[:user_id].present?
        User.find_by(id: params[:user_id]) || User.first
      else
        role = params[:role] || "coach"
        User.find_by(role: role) || User.first
      end
    end
  end
  
  def all_users
    @all_users ||= User.all.order(:role, :name)
  end
end
