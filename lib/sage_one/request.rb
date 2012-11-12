require 'multi_json'

module SageOne
  module Request
    def delete(path, options={}, raw=false)
      request(:delete, path, options, raw)
    end

    def get(path, options={}, raw=false)
      request(:get, path, options, raw)
    end

    def post(path, options={}, raw=false)
      request(:post, path, options, raw)
    end

    def put(path, options={}, raw=false)
      request(:put, path, options, raw)
    end

    private

    def request(method, path, options, raw)

      response = connection(raw).send(method) do |request|
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

      if raw
        response
      elsif auto_traversal && ( next_url = links(response)["next"] )
        response.body + request(method, next_url, options, raw)
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
