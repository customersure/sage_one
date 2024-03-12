require 'faraday'

# @api private
module FaradayMiddleware

  # Checks the status of the API request and raises
  # relevant exceptions when detected.
  # @see SageOne::Error SageOne::Error for possible errors to rescue from.
  #
  # @api private
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
        when (400..499)
          raise SageOne::ClientError, error_message(response)
        when 500
          raise SageOne::InternalServerError, error_message(response)
        when 501
          raise SageOne::NotImplemented, error_message(response)
        when 502
          raise SageOne::BadGateway, error_message(response)
        when 503
          raise SageOne::ServiceUnavailable, error_message(response)
        when (500..599)
          raise SageOne::ServerError, error_message(response)
        end
      end
    end

    private

    def error_message(response)
      JSON.unparse({
        method: response[:method],
        url:    response[:url].to_s,
        status: response[:status],
        body:   format_response_body(response[:body])
      })
    end

    def format_response_body(response_body_error_messages)
      return [] if response_body_error_messages.nil?

      response_body_error_messages = [response_body_error_messages] unless response_body_error_messages.is_a?(Array)

      response_body_error_messages.map do |message|
        data_code    = message['$dataCode'].presence
        source       = message['$source'].presence
        message_text = message['$message'].presence || message['error_description'].presence

        formatted_message_parts = []
        formatted_message_parts << "#{data_code}:" if data_code
        formatted_message_parts << source if append_source_in_error_message?(source)
        formatted_message_parts << message_text if message_text

        formatted_message = formatted_message_parts.join(' ')
        formatted_message.empty? ? message : formatted_message
      end
    end

    def append_source_in_error_message?(error_source)
      to_ignored_sources = ['base']

      return false if error_source.blank? || to_ignored_sources.include?(error_source)

      true
    end
  end
end
