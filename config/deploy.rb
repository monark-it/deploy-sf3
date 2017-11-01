# config valid only for current version of Capistrano
# lock '3.5.0'

set :application, 'sf3'
set :repo_url, 'git@github.com:multiinfo/sf3.git'

# symfony-standard edition directories
set :app_path, "app"
set :web_path, "web"
set :var_path, "var"
set :bin_path, "bin"
set :symfony_directory_structure, 3

# The next 3 settings are lazily evaluated from the above values, so take care
# when modifying them
set :app_config_path, "app/config"
set :log_path, "var/logs"
set :cache_path, "var/cache"

set :symfony_console_path, "bin/console"

set :linked_files, %w{app/config/parameters.yml}
set :linked_dirs, %w{ var/logs vendor web/uploads}

set :format, :pretty
set :log_level, :debug
set :keep_releases, 3

set :file_permissions_paths, ["var/logs", "var/cache", "var/sessions", "web/uploads"]
set :file_permissions_users, ["www-data"]

before "deploy:updated", "deploy:set_permissions:acl"

after 'deploy:starting', 'composer:install_executable'
after 'deploy:updated', 'symfony:assets:install'
after 'deploy:updated', 'symfony:assetic:dump'

namespace :deploy do
  task :migrate do
    # invoke 'symfony:console', 'doctrine:migrations:migrate', '--no-interaction'
  end
  task :clean_schema do
    invoke 'symfony:console', 'doctrine:schema:drop', '--force'
    invoke 'symfony:console', 'doctrine:schema:update', '--force'
    invoke 'symfony:console', 'doctrine:fixtures:load', '--no-interaction' # Comment this if you have no fixtures
  end
end
