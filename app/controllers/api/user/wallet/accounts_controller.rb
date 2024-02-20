module Api
  module User
    module Wallet
      class AccountsController < BaseController

        fetch_resource_and_collection! do
          model_klass "Account"
          query_scope do |query|
            query.where(wallet_id: current_wallet.id)
          end
          got_resource_callback do |account|
            account.wallet = current_wallet if account.new_record?
            account
          end
          resource_identifier "currency_id"
          resource_finder_key "currency"
          resource_actions [:show, :create, :destroy, :transactions, :balance]
        end

        def index
          present records
        end

        def create
          if record.save
            present record
          else
            present_error record.errors.messages
          end
        end

        def show
          present record.as_json(balance_params)
        end

        def transactions
          present record.entries.search(**search_params), 200, { pagination: { per_page: params[:transactions_per_page] || 25, page: params[:transactions_page] || 1 } }
        end

        def destroy
          record.destroy
          present record
        end

        protected

        def search_params
          search = params[:search]
          search = ::ActionController::Parameters.new({}) unless search.is_a?(ActionController::Parameters)
          search.permit!.slice(:from, :to).to_h.deep_symbolize_keys
        end

        def account_params
          params.permit(:currency)
        end

        def balance_params
          params.permit!.slice(:from, :to).to_h.deep_symbolize_keys
        end

      end
    end
  end
end