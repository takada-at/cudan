class Cudan::Main
    require 'optparse'
    def main
        opts = OptionParser.new("Usage: #{File::basename($0)} [OPTIONS] URL")
        opts.on("-v", "--version", "show version") do
            puts "%s %s" %[File.basename($0), Cudan::VERSION]
            puts "ruby %s" % RUBY_VERSION
            exit
        end
        opts.on('-q QUERY', '--query QUERY', 'query') do |q|
            @query = q
        end
        opts.on('-e EXPECT_STRING', '--expects EXPECT_STRING', 'expect string') do |ex|
            @expects = ex
        end
        opts.on('-u USER_AGENT', '--user-agent USER_AGENT', 'set user agent') do |ua|
            @ua = ua
        end
        opts.on('--show-body', 'show body') do |b|
            @showbody = b
        end
        opts.version = Cudan::VERSION
        opts.parse!(ARGV)
        @url = ARGV[0]
        unless @url
            puts opts.to_s
            exit
        end
        if /\/(.*)\// =~ @query
            klass = Cudan::RegexpCudan
            @query = $~[1]
        else
            klass = Cudan::XpathCudan
        end
        instance = klass::new
        instance.set_header('UserAgent', @ua) if @ua
        instance.showbody = @showbody
        instance.execute(@query, @expects, @url)
    end
end
