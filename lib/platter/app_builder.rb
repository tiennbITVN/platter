module Platter
  class AppBuilder < Rails::AppBuilder
    PORT = 3000

    def readme
      template "README.md.erb", "README.md"
    end

    def replace_gemfile
      remove_file "Gemfile"
      template "Gemfile.erb", "Gemfile"
    end

    #API builds
    #
    def add_api_support
      inject_into_file "Gemfile", after: "ruby \"#{Platter::RUBY_VERSION}\"" do
        %Q{

gem "versionist"
gem "active_model_serializers", github: "rails-api/active_model_serializers", branch: "0-8-stable"
        }
      end
    end

    def add_api_version_directories
      empty_directory "app/controllers/api/v1/"
    end

    def add_api_version_base_controller
      template "base_api_controller.erb", "app/controllers/api/v1/base_controller.rb"
    end

    def provide_api_routes
      template "api_routes.erb", "config/routes.rb", force: true
    end

    #GIT builds
    #
    def setup_git
      remove_file '.gitignore'
      copy_file "platter_gitignore", ".gitignore"
      git :init
    end

    def provide_first_commit
      git add: "."
      git commit: "-m 'Project initialization using Platter'"
    end

    # Docker Build
    #
    def setup_docker_compose
      template "docker-compose.yml.erb", "docker-compose.yml"
    end

    def provide_dev_entrypoint
      template "dev-entrypoint.sh", "dev-entrypoint"
      run "chmod a+x dev-entrypoint"
    end

    def provide_db_script
      template "check_or_setup_db.erb", "bin/check_or_setup_db"
      run "chmod a+x bin/check_or_setup_db"
    end

    def provide_attach_script
      template "attach.erb", "bin/attach"
      run "chmod a+x bin/attach"
    end

    #Server build
    #
    def setup_server
      template "Procfile", "Procfile"
    end

    # Development builds
    #
    def provide_development_setup_bin
      template "bin_development_setup.rb", "bin/setup", port: PORT, force: true
      run "chmod a+x bin/setup"
    end

    def setup_development_mail_delivery_strategy
      inject_into_file "config/environments/development.rb",
        %Q{

  # We use mailcatcher to preview emails
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  config.action_mailer.default_url_options = { host: "localhost:#{PORT}" }
  config.action_mailer.asset_host = "http://localhost:#{PORT}"
        },
          after: "config.action_mailer.raise_delivery_errors = false"
    end

    def fix_i18n_deprecation_warning
      inject_into_class 'config/application.rb', 'Application',
        %Q{
    config.i18n.enforce_available_locales = true\n}
    end

    def provide_generators_configuration
      inject_into_file 'config/application.rb',
        %q{
    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
    end

    config.autoload_paths += %W(#{config.root}/lib)
        },
          after: "config.active_record.raise_in_transactional_callbacks = true"
    end

    #TEST builds
    #
    def init_rspec
      generate "rspec:install"
    end

    def add_support_rspec_files
      empty_directory "spec/support/"
      template "rspec_support_database_cleaner.erb", "spec/support/database_cleaner.rb"
      template "rspec_support_factory_girl.erb", "spec/support/factory_girl.rb"
      template "rspec_support_i18n.erb", "spec/support/i18n.rb"
    end

    #STAGING builds
    #
    def copy_production_env_to_staging
      template "production_env.erb", "config/environments/staging.rb"
    end

    #MAILER builds
    #
    def init_sendgrid_initialize_file
      template "mailer_initializer_config.erb", "config/initializers/mailer_setup.rb"
    end


    def add_exception_notification_mailer_configuration
      %w{ production staging }.each do |env|
        inject_into_file "config/environments/#{env}.rb",
          %Q{

  #Exception Notification configuration
  config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[#{app_name}] ",
    :sender_address => %{"Exception" <exception@#{app_name.downcase}-#{env}.com>},
    :exception_recipients => %w{}
  }
          },
            after: "config.active_record.dump_schema_after_migration = false"
      end
    end

    def add_smtp_configuration_for_deployment
      %w{ production staging }.each do |env|
        inject_into_file "config/environments/#{env}.rb",
          %Q{

  # STMP configuration
  config.action_mailer.default_url_options = { :host => ENV['HOST_DEFAULT_URL'], only_path: false }
  config.action_mailer.delivery_method = :smtp
          },
            after: "config.active_record.dump_schema_after_migration = false"
      end
    end

    def app
      super
      if options["skip_assets"]
        remove_dir "app/assets"
        remove_dir "app/views"
        remove_dir "app/helpers"
      end
    end

    def vendor_stylesheets
      empty_directory_with_keep_file 'vendor/assets/stylesheets' unless options[:skip_assets]
    end
  end
end
