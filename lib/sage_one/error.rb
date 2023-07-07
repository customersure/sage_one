module SageOne

  # Custom error class for rescuing from all SageOne errors
  class Error < StandardError; end

  # Raised when SageOne returns a 400 HTTP status code
  class BadRequest < Error; end

  # Raised when SageOne returns a 401 HTTP status code
  class Unauthorized < Error; end

  # Raised when SageOne returns a 403 HTTP status code
  class Forbidden < Error; end

  # Raised when SageOne returns a 404 HTTP status code
  class NotFound < Error; end

  # Raised when SageOne returns a 406 HTTP status code
  class NotAcceptable < Error; end

  # Raised when SageOne returns a 409 HTTP status code
  class Conflict < Error; end

  # Raised when SageOne returns a 422 HTTP status code
  class UnprocessableEntity < Error; end

  # Raised when SageOne returns a 4xx HTTP status code that does not have a specific exception class defined.
  class ClientError < Error; end

  # Raised when SageOne returns a 500 HTTP status code
  class InternalServerError < Error; end

  # Raised when SageOne returns a 501 HTTP status code
  class NotImplemented < Error; end

  # Raised when SageOne returns a 502 HTTP status code
  class BadGateway < Error; end

  # Raised when SageOne returns a 503 HTTP status code
  class ServiceUnavailable < Error; end

  # Raised when SageOne returns a 5xx HTTP status code that does not have a specific exception class defined.
  class ServerError < Error; end
end
