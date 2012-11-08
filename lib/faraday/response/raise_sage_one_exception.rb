require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class RaiseSageOneException < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 403
          raise SageOne::Unauthorized, error_message_400(response)
        when 404
          raise SageOne::NotFound, error_message_400(response)
        when 422
          raise SageOne::UnprocessableEntity, error_message_400(response)
        end
      end
    end

    def initialize(app)
      super app
      @parser = nil
    end

    private

    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{json_body(response[:body])}"
    end

    def json_body(body)
      ::JSON.parse(body) if body && body.kind_of?(String)
    end

  end
end
