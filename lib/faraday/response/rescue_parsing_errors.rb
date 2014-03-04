require 'faraday'

# @api private
module FaradayMiddleware

  # Handle Sage One's habit of sending HTTP errors even when JSON is requested.
  #
  # @api private
  class RescueParsingErrors < Faraday::Middleware
    def call(env)
      begin
        @app.call(env)
      rescue Faraday::Error::ParsingError => e
        raise SageOne::ParsingError.new("SageOne sent HTML instead of JSON. Status was #{env[:status]}.")
      end
    end
  end
end
