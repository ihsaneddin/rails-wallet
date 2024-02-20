require 'httparty'
require 'uri'

module LatestStockPrice
  class Api

    include HTTParty

    base_uri "https://#{LatestStockPrice.api_host}"

    def initialize options = {}
      @headers = default_headers.merge(options[:headers] || {})
    end

    def price indices: , identifier: nil
      options = { headers: @headers, query: { "Indices" => indices, identifier: identifier } }
      self.class.get("/price", options)
    end

    def price_all identifier: nil
      options = { headers: @headers, query: { identifier: identifier } }
      self.class.get("/any", options)
    end

    def prices indices: , identifier: nil
      options = { headers: @headers, query: { "Indices" => indices, identifier: identifier } }
      self.class.get("/price", options)
    end

    def default_headers
      {
        "Content-Type" => "application/json",
        "X-RapidAPI-Key" => LatestStockPrice.api_key,
        "X-RapidAPI-Host" => LatestStockPrice.api_host

      }
    end

    def url
      URL("https://#{LatestStockPrice.api_host}")
    end

  end
end