require 'fileutils'

here = File.dirname(__FILE__)
there = defined?(RAILS_ROOT) ? RAILS_ROOT : "#{here}/../../.."

FileUtils.mkdir_p("#{there}/public/javascripts/uploadify/")

puts "Installing Uploadify..."
FileUtils.cp_r("#{here}/public/javascripts/uploadify/", "#{there}/public/javascripts/uploadify/")
FileUtils.cp("#{here}/public/images/cancel.png", "#{there}/public/images/")

puts "================================Installation Complete!==========================================="

puts IO.read(File.join(File.dirname(__FILE__), '../README.rdoc'))