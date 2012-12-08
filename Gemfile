if ['RAILS_ENV'] == 'test'
  Dir.glob File.expand_path("../plugins/redmine_charts/Gemfile.local", __FILE__) do |file|
    puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
    instance_eval File.read(file)
  end
end
