require 'rubygems'
require 'ww'

class Requests < Array
    def self::from_a(ar)
        is = self.new
        ar.each do |i|
            is << i
        end
        is
    end
    def filter &pred
        Requests::from_a(find_all(&pred))
    end
    def params p
        filter do |rq|
            p.any?{|k,v| rq.params[k] == v}
        end
    end
    def request_method method
        filter {|rq|
            rq.request_method == method
        }
    end
    def filter_opt p
        filter do |rq|
            p.any?{|k,v| rq[k] == v}
        end
    end
end
class Ww::Server
    def compile(path)
        keys = []
        if path.respond_to? :to_str
            special_chars = %w{. + ( )}
            pattern =
                path.to_str.gsub(/((:\w+)|[\*#{special_chars.join}])/) do |match|
                case match
                when "*"
                    keys << 'splat'
                    "(.*?)"
                when *special_chars
                    Regexp.escape(match)
                else
                    keys << $2[1..-1]
                    "([^/?&#]+)"
                end
            end
            [/^#{pattern}$/, keys]
        elsif path.respond_to?(:keys) && path.respond_to?(:match)
            [path, path.keys]
        elsif path.respond_to? :match
            [path, keys]
        else
            raise TypeError, path
        end
    end
    def filter &pred
        Requests::from_a(requests).reverse.filter &pred
    end
    def path path, opt=nil
        reg,p = compile(path)
        r = filter do |rq|
            rq.path =~ reg
        end
        r = r.params(opt) if opt
        r
    end
end
