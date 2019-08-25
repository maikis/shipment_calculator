task default: :run

desc 'Run application'
task :run do |_task, args|
  sh "bundle exec ruby cli.rb #{args.first}"
end

desc 'Run specs'
task :test do
  sh 'bundle exec rspec'
end
