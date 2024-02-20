module Api
  class SessionsController < ::ApplicationController

    def create
      user = ::User.find_or_initialize_by(sessions_params)
      unless user.persisted?
        user.save
      end
      if user.errors.any?
        present_error user.errors.messages, 422
      else
        present user.as_json
      end
    end

    protected
      def sessions_params
        params.permit(:name, :email)
      end

  end
end