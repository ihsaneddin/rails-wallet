require "latest_stock_price/version"
require "latest_stock_price/engine"
require 'latest_stock_price/configuration'

module LatestStockPrice
  # Your code goes here...

  extend Configuration

  class << self

    delegate :price, :prices, :price_all, to: :api

    def api
      @api ||= LatestStockPrice::Api.new
    end

    def api= val
      unless val.is_a?(LatestStockPrice::Api)
        raise "invalid value, should be instance of LatestStockPrice::Api Class"
      end
      @api = val
    end

  end


end

require "latest_stock_price/api"
