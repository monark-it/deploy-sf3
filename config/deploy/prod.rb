set :stage, :dev
set :symfony_env, "prod"

set :branch, 'master' # your staging branch
set :deploy_to, '/var/www/sf3/prod' # path on production server

after 'deploy:updated', 'deploy:migrate' # Comment this if you don't want update the database

set :controllers_to_clear, ['app_*']
set :composer_install_flags, '--prefer-dist --no-interaction --optimize-autoloader'

server 'IP_ADDRESS', user: 'johndoe', port: 22, roles: %w{app db web} # edit IP / Port and SSH user of your production server
SSHKit.config.command_map[:composer] = "php #{shared_path.join("composer.phar")}"
