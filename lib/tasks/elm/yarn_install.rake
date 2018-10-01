
namespace :elm do
  desc 'Verifies if Elm is installed'
  task :yarn_install => :env do
    Dir.chdir(@path) do
      system 'yarn install --no-progress --frozen-lockfile --production'
    end
  end
end
