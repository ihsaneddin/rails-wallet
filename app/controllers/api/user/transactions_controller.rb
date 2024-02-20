module Api
  module User
    class TransactionsController < BaseController

      fetch_resource_and_collection! do
        model_klass "Entry"
        query_scope do
          current_wallet.entries.search(**search_params)
        end
      end

      def index
        present records
      end

      def show
        present record
      end

      def destroy
        record.destroy
        present record
      end

      protected

      def search_params
        search = params[:search]
        search = ActionController::Parameters.new({}) unless search.is_a?(ActionController::Parameters)
        search.permit!.slice(:from, :to, :currency).to_h.deep_symbolize_keys
      end

    end
  end
end