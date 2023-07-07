require 'multi_json'

module SageOne
  # This helper methods in this module are used by the public api methods.
  # They use the Faraday::Connection defined in connection.rb for making
  # requests. Setting 'SageOne.raw_response' to true can help with debugging.
  # @api private
  module Request
    def delete(path, options={})
      request(:delete, path, options)
    end

    def get(path, options={})
      request(:get, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    def put(path, options={})
      request(:put, path, options)
    end

    private

    def request(method, path, options)
      options = format_datelike_objects!(options) if options.present?
      request_options = retrieve_request_options(api_endpoint, content_type)
      response = connection(request_options).send(method) do |request|
        case method
        when :delete, :get
          options.merge!('$startIndex' => options.delete(:start_index)) if options[:start_index]
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = MultiJson.dump(options) unless options.empty?
        end
        request.headers['Host'] = request_host if request_host
      end

      if raw_response
        response
      elsif auto_traversal && ( next_url = links(response)["next"] )
        response.body + request(method, next_url, options)
      else
        response.body
      end
    end

    def retrieve_request_options(endpoint, content_type)
      {
        headers:  { 'Accept'        => "application/json; charset=utf-8",
                    'User-Agent'    => user_agent,
                    'Content-Type'  => content_type,
                    'X-Business'    => business_id },
        proxy:    proxy,
        ssl:      { verify: false },
        url:      endpoint
      }
    end

    def links(response)
      links = ( response.headers["X-SData-Pagination-Links"] || "" ).split(', ').map do |link|
        url, type = link.match(/<(.*?)>; rel="(\w+)"/).captures
        [ type, url ]
      end

      Hash[ *links.flatten ]
    end

    # It Converts "ruby date objects" into correctly formatted "date strings".
    # It modifies given hash directly, without creating a separate copy.
    def format_datelike_objects!(options)
      options.each do |key, value|
        case value
        when Date
          options[key] = value.strftime('%d/%m/%Y')
        when Array
          value.each { |item| format_datelike_objects!(item) if item.is_a?(Hash) }
        when Hash
          format_datelike_objects!(value)
        end
      end
    end

  end
end
