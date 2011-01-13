require 'rubygems'
require 'ww'
require 'lib/cudan'
require File::dirname(__FILE__) + '/wwutil'


port = 3080 + rand(10)
baseurl  = "http://localhost:#{port}"
html = <<EOS
<html>
    <body>
       <p class='hoge'>abcdefg</p>
    </body>
</html>
EOS
##
WW::Server[:server] ||= WW::Server::build_double(port) do
    spy.get('/regexp'){
        body = html
    }
    spy.get('/xpath'){
        body = html
    }
end
WW::Server.start_once
describe Cudan, 'request for localhost' do
    it 'test with regexp' do
        url = baseurl + '/regexp'
        o = Cudan::RegexpCudan::new
        o.execute('<p class=\'hoge\'>(.*)</p>', 'abcdefg', url)
    end
    it 'test with xpath' do
        url = baseurl + '/xpath'
        o = Cudan::XpathCudan::new
        o.execute('//p[@class="hoge"]/text()', 'abcdefg', url)
        o.execute('//p[@class="hoge"]', 'abcdefg', url)
    end
end
