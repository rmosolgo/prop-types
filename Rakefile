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
  sh("rake compile_js")
  sh("git checkout gh-pages")
  sh("git checkout master web/index.html")
  sh("cp web/index.html ./")
  sh("cp web/build.js ./")
  sh("git add index.html build.js")
  sh("git commit -m rebuild")
  sh("git push origin gh-pages")
  sh("rm index.html build.js")
  sh("git checkout master")
end
