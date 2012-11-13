require 'faraday'
require 'faraday_middleware/response_middleware'

# @api private
module FaradayMiddleware

  # Middleware to strip out Sage's pagination SData from the body and place
  # it in a custom response header instead (Using familiar 'Link' header syntax).
  # This just leaves the resources in the body which can then be recursively
  # collected later by following the links.
  #
  # @api private
  class ConvertSdataToHeaders < ResponseMiddleware

    SDATA_START_INDEX    = "$startIndex".freeze
    SDATA_TOTAL_RESULTS  = "$totalResults".freeze
    SDATA_ITEMS_PER_PAGE = "$itemsPerPage".freeze
    SDATA_RESOURCES      = "$resources".freeze
    SDATA_HEADER_NAME    = "X-SData-Pagination-Links".freeze

    def call(env)
      @app.call(env).on_complete do
        @response = env[:response]

        # Only proceed if SData is actually present
        next unless @response.body && @response.body.kind_of?(Hash) && @response.body[SDATA_TOTAL_RESULTS]

        @url  = Addressable::URI::parse(env[:url])
        @url.query_values ||= {}

        # Add 'next' link, if we're not on the last page
        add_link(next_start_index, 'next') if next_start_index < @response.body[SDATA_TOTAL_RESULTS]

        # Add 'prev' link if we're not on the first page
        add_link(prev_start_index, 'prev') if prev_start_index >= 0

        # Special case: If we're halfway through the first page, don't allow negative start indices
        add_link(0, 'prev') if @response.body[SDATA_START_INDEX] != 0 && prev_start_index < 0

        # Add the page links into the header
        @response.headers[SDATA_HEADER_NAME] = @links.join(', ') unless @links.empty?

        # Strip out the SData from the body
        env[:body] = @response.body[SDATA_RESOURCES]
      end
    end

    def initialize(app)
      @links = []
      super app
    end

    private

    def add_link(start_index, rel)
      @url.query_values = @url.query_values.merge({ SDATA_START_INDEX => start_index })
      @links << %Q{<#{@url.to_str}>; rel="#{rel}"}
    end

    def next_start_index
      @response.body[SDATA_START_INDEX] + @response.body[SDATA_ITEMS_PER_PAGE]
    end

    def prev_start_index
      @response.body[SDATA_START_INDEX] - @response.body[SDATA_ITEMS_PER_PAGE]
    end

  end
end