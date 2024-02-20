module Authenticate

  extend ActiveSupport::Concern

  included do
    prepend_before_action :authenticate!
  end

  def authenticate!
    current_user ? current_user : reject_unauthenticated!
  end

  def current_user
    @current_user ||= User.find_by_token(request.headers["Authorization"])
  end

  def reject_unauthenticated!
    render json: { message: "Forbidden" }, status: 401
  end

end
