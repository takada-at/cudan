class Cudan::Main
    require 'optparse'
    def main
        opts = OptionParser.new("Usage: #{File::basename($0)} [OPTIONS] URL")
        opts.on("-v", "--version", "show version") do
            puts "%s %s" %[File.basename($0), InternetHakai::VERSION]
            puts "ruby %s" % RUBY_VERSION
            exit
        end
        @url = ARGV[0]
        unless @url
            puts opts.to_s
            exit
        end
        opts.on('-q', '--query', 'query') do |q|
            @query = q
        end
        opts.on('-e', '--expects', 'expect string') do |ex|
            @expects = ex
        end
        opts.version = Cudan::VERSION
        opts.parse!(ARGV)
        if /\/(.*)\// =~ @query 
            klass = Cudan::RegexpCudan
            @query = $~[1]
        else
            klass = Cudan::XpathCudan
        end
        instance = klass::new
        instance.execute(@query, @expect, @url)
    end
end
