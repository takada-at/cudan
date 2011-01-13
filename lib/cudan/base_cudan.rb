require 'net/http'
module Cudan
    GET="GET"
    POST="POST"
    PUT="PUT"
    DELETE="DELETE"
    class BaseCudan
        def initialize
            @headers = {}
            @showbody = false
        end
        attr_accessor :showbody
        def set_header key, value
            @headers[key] = value
        end
        def fetch url, method=GET, body=nil
            host, port, path = Util::parse_url(url)
            @post_string = body
            if method == GET
                req = Net::HTTP::Get::new(path, @headers)
            elsif method == POST
                req = Net::HTTP::Post::new(path, @headers)
            end
            response = nil
            Net::HTTP.start(host, port) do |http|
                @starttime = Time::now
                response = http.request(req, @post_string)
                @response_time = Time::now - @starttime
            end
            if response
                @response = response.body.to_s
            else
                @response = ''
            end
            if @showbody
                Logger.log(@response, 2)
            end
        end
        def execute query, expect, url, method=GET, body=nil
            fetch(url, method, body)
            @query_result = do_query(query)
            r = do_expect(expect)
            unless r
                do_message
                exit 1
            else
            end
        end
        def do_message
            Logger.log 'failure:'
            Logger.log @query_result.gsub(/^(.*)$/){|r| "\t" + r}
        end
        def do_query query
            @response.include? query ? query : ''
        end
        def do_expect expect
            @query_result.include? expect
        end
    end
    class Util
        def self::parse_url url
            hostpath = url.slice(url.index('://')+3, url.size)
            if pathstart = hostpath.index('/')
                host = hostpath.slice(0, pathstart)
                path = hostpath.slice(pathstart, hostpath.size)
            else
                host = hostpath
                path = '/'
            end
            if portstart = host.index(':')
                host, port = host.split(':')
                port = port.to_i
            else
                port = 80
            end
            [host, port, path]
        end
    end
end
