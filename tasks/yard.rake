desc 'Generate YARD documentation'
task :yard do
  readme = File.expand_path('../../README.md', __FILE__)
  sh("yardoc -o ydoc -r #{readme}")
end
