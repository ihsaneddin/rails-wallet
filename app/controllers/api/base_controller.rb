module Api
  class BaseController < ::ApplicationController

    include Resourceful

    rescue_from Exception do |e|
      present_error e.message, 500
    end

  end
end