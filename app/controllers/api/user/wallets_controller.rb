module Api
  module User
    class WalletsController < BaseController

      def show
        present current_wallet.as_json
      end

      def destroy
        current_wallet.destroy
        present current_wallet.as_json
      end

      def deposit
        @deposit = current_wallet.deposit(**deposit_params)
        if @deposit.errors.any?
          present @deposit.errors.messages, 422
        else
          present @deposit.as_json
        end
      end

      def withdraw
        @withdraw = current_wallet.withdraw(**withdraw_params)
        if @withdraw.errors.any?
          present @withdraw.errors.messages, 422
        else
          present @withdraw.as_json
        end
      end

      def transfer
        @transfer = current_wallet.transfer(**transfer_params)
        if @transfer.errors.any?
          present @transfer.errors.messages, 422
        else
          present @transfer.as_json
        end
      end

      def destroy
        #current_wallet.destroy
        present current_wallet
      end

      protected

        def deposit_params
          params.permit(:amount, :currency, :description, :date).to_h.deep_symbolize_keys
        end

        def withdraw_params
          params.permit(:amount, :currency, :description, :date).to_h.deep_symbolize_keys
        end

        def transfer_params
          params.permit(:amount, :currency, :description, :date, :target_wallet_number).to_h.deep_symbolize_keys
        end

    end
  end
end