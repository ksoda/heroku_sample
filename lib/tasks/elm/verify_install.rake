# frozen_string_literal: true

namespace :elm do
  desc 'Verifies if Elm is installed'
  task verify_install: :env do
    begin
      _node_version = `node -v`
    rescue Errno::ENOENT
      warn 'Node.js not installed' && exit!
    end

    begin
      _yarn_version = `yarn --version`
    rescue Errno::ENOENT
      warn 'Yarn not installed' && exit!
    end
    Dir.chdir(@path) do
      _elm_version = '$(yarn bin)/elm --version'
    end
    puts 'Installation verified'
  end
end
