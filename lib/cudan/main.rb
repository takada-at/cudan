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
            if q==''
                q = '/.*'
            end
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
        @mode = :css
        opts.on('-m MODE', '--mode MODE', 'query mode. [regexp|xpath|css].', [:regexp, :xpath, :css]) do |m|
            @mode = m
        end
        opts.on('-x QUERY', 'alias for "-q query --mode=xpath"') do |q|
            @mode = :xpath
            @query = q
        end
        opts.on('-r QUERY', 'alias for "-q query --mode=regexp"') do |q|
            @mode = :regexp
            @query = q
        end
        opts.version = Cudan::VERSION
        opts.parse!(ARGV)
        @url = ARGV[0]
        unless @url
            puts opts.to_s
            exit
        end
        if /^\/(.+)\/$/ =~ @query
            @mode = :regexp
            @query = $~[1]
        end
        case @mode
        when :regexp
            @klass = Cudan::RegexpCudan
        when :css
            @klass = Cudan::XpathCudan
        when :xpath
            @klass = Cudan::XpathCudan
        end
        instance = @klass::new
        instance.set_header('UserAgent', @ua) if @ua
        instance.showbody = @showbody
        instance.execute(@query, @expects, @url)
    end
end
