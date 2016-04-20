require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test" << "lib"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

task :compile_js do
  require "opal"
  Opal.append_path './lib'
  Opal.append_path './web'
  File.binwrite "./web/build.js", Opal::Builder.build("application").to_s
end

task :deploy do
  `rake compile_js`
  `git checkout gh-pages`
  `cp index.html ./`
  `cp build.js ./`
  `git ct -m "rebuild"`
  `git push origin gh-pages`
end
