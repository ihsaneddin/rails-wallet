module LatestStockPrice
  module Configuration
    mattr_accessor :api_key
    @@api_key = ""
    mattr_accessor :api_host
    @@api_host = "latest-stock-price.p.rapidapi.com"


    def config &block
      block.arity.zero? ? instance_eval(&block) : yield(self)
    end

  end
end