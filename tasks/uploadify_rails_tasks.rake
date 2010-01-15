# desc "Explaining what the task does"
# task :uploadify_rails do
#   # Task goes here
# end


task :uploadify_rails do
  desc "Installs in the images, flash, and javascript for uploadify"
  task :install do
    
    puts "================================Installation Complete!==========================================="
    
    puts IO.read(File.join(File.dirname(__FILE__), '../README'))
  end
end