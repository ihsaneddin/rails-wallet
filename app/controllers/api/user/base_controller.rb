module Api
  module User
    class BaseController < ::Api::BaseController

      include Authenticate
      include Resourceful

      def current_wallet
        return @current_wallet if @current_wallet
        current_user.make_wallet if current_user.wallet.blank?
        @current_wallet ||= current_user.wallet
      end

    end
  end
end