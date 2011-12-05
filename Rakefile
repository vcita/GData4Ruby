begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|

    gemspec.name = "vcita-gdata4ruby"
    gemspec.summary = %Q{A full featured wrapper for interacting with the base Google Data API}
    gemspec.email = ["mike@seabourneconsulting.com","email2ants@gmail.com", "ui-design@vestaldesign.com"]
    gemspec.homepage = "https://github.com/vcita/GData4Ruby"
    gemspec.authors = ["Mike Reich","Anthony Underwood", "David Pitman"]
    gemspec.add_dependency 'oauth', '>= 0.4.4'
    gemspec.files = FileList["README.md", "CHANGELOG", "lib/gdata4ruby.rb", "lib/gdata4ruby/base.rb", "lib/gdata4ruby/gdata_object.rb", "lib/gdata4ruby/request.rb", "lib/gdata4ruby/service.rb", "lib/gdata4ruby/oauth_service.rb", "lib/gdata4ruby/acl/access_rule.rb", "lib/gdata4ruby/utils/utils.rb"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
