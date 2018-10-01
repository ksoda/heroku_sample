namespace :elm do
  desc 'Verifies if Elm is installed'
  task :verify_install => :env do
    begin
      node_version = `node -v`
    rescue Errno::ENOENT
      $stderr.puts 'Node.js not installed' && exit!
    end

    begin
      yarn_version = `yarn --version`
    rescue Errno::ENOENT
      $stderr.puts 'Yarn not installed' && exit!
    end
    Dir.chdir(@path) do
      elm_version = "$(yarn bin)/elm --version"
    end
    puts "Installation verified"
  end
end
