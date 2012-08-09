Pry.config.editor = "subl"

Pry.config.hooks.add_hook(:before_session, :say_hi) do
  puts "hello"
end

Pry.config.hooks.add_hook(:after_session, :say_bye) do
  puts "Goodbye and God bless"
end

# Prompt with ruby version
Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

require 'hirb'

#load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails) && Rails.env
