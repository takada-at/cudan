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
describe Cudan::RegexpCudan, 'request for localhost' do
    it 'should raise no error with regexp' do
        url = baseurl + '/regexp'
        o = Cudan::RegexpCudan::new
        expect{
             o.execute('<p class=\'hoge\'>(.*)</p>', 'abcdefg', url)
        }.to_not raise_error(nil)
    end
end
describe Cudan::XpathCudan, 'request for localhost' do
    it 'should raise no error with xpath' do
        url = baseurl + '/xpath'
        o = Cudan::XpathCudan::new
        expect{
            o.execute('//p[@class="hoge"]/text()', 'abcdefg', url)
        }.to_not raise_error(nil)
        expect{
            o.execute('//p[@class="hoge"]', 'abcdefg', url)
        }.to_not raise_error(nil)
    end
    it 'should raise error with xpath' do
        url = baseurl + '/xpath'
        o = Cudan::XpathCudan::new
        expect{ o.execute('//p[@class="fuga"]', 'hoge', url) }.to raise_error(SystemExit)
    end
end
