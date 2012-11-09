require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class RaiseSageOneException < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise SageOne::BadRequest, error_message(response)
        when 401
          raise SageOne::Unauthorized, error_message(response)
        when 403
          raise SageOne::Forbidden, error_message(response)
        when 404
          raise SageOne::NotFound, error_message(response)
        when 409
          raise SageOne::Conflict, error_message(response)
        when 422
          raise SageOne::UnprocessableEntity, error_message(response)
        end
      end
    end

    def initialize(app)
      super app
      @parser = nil
    end

    private

    def error_message(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]} #{response[:body].nil? ? '' : response[:body][:error]}"
    end

  end
end
