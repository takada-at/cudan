require 'rubygems'
$LOAD_PATH << File::join(File::dirname(__FILE__), 'lib')
require 'lib/cudan'
GEMSPEC = Gem::Specification::new do |s|
    s.name = 'cudan'
    s.version = Cudan::VERSION
    s.author = 'takada-at'
    s.email = 'nightly at at-akada dot org'
    s.summary = 'functional test tool'
    s.platform = Gem::Platform::RUBY
    s.required_ruby_version = '>= 1.8.6'
    s.executables = ['cudan']
    s.default_executable = 'cudan'
    s.files = Dir::glob("{lib,bin,test}/**/*") + ['README', 'CHANGES']
    s.has_rdoc = false
    s.homepage = 'http://github.com/takada-at/cudan'
    s.rubyforge_project = ''
    s.description = <<EOF
simple functinal test tool
EOF
end
