require 'multi_json'

module SageOne
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

      response = connection.send(method) do |request|
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

    def links(response)
      links = ( response.headers["Link"] || "" ).split(', ').map do |link|
        url, type = link.match(/<(.*?)>; rel="(\w+)"/).captures
        [ type, url ]
      end

      Hash[ *links.flatten ]
    end
  end
end
