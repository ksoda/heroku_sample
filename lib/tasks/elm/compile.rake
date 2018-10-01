# frozen_string_literal: true

require 'fileutils'
def enhance_assets_precompile
  Rake::Task['assets:precompile'].enhance do
    Rake::Task['elm:compile'].invoke
  end
end
namespace :elm do
  desc 'Compile Elm using its compiler for production'
  task compile: [:env, 'elm:verify_install'] do
    dist = @app_root.join('public')
    Dir.chdir(@path) do
      system "$(yarn bin)/elm make Main.elm --output=#{dist.join('main.js')}"
      FileUtils.cp([@app_root.join(@path, 'node_modules/todomvc-app-css/index.css')], dist, verbose: true)
    end
  end
end

if Rake::Task.task_defined?('assets:precompile')
  enhance_assets_precompile
else
  Rake::Task.define_task('assets:precompile' => ['elm:yarn_install', 'elm:compile'])
end
