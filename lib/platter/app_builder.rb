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
      run "git init"
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
      copy_file "config/environments/production.rb", "config/environments/staging.rb"
    end

  end
end
