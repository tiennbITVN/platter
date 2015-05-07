require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Platter
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database. PostgreSQL by default."

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    class_option :skip_turbolinks, type: :boolean, default: true,
      desc: "Skips the turbolinks gem"

    class_option :api, type: :boolean, default: false,
      desc: "Adds API support gems"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    def finish_template
      invoke :platter
      super
    end

    def platter
      invoke :custom_gemfile
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_staging_environment
      invoke :add_active_job_configuration
      invoke :add_api_support
      invoke :setup_server
      invoke :setup_git
    end

    def custom_gemfile
      build :replace_gemfile

      bundle_command 'install'
    end

    def add_api_support
      if options[:api]
        say "Adding API support"
        build :add_api_support
        build :add_api_version_directories
        build :add_api_version_base_controller
        build :provide_api_routes
      end
    end

    def setup_git
      say "Initializing git"
      build :setup_git
    end

    def setup_server
      say "Setting up the server"
      build :setup_server
    end

    def setup_development_environment
      say "Setting up the development environment"
      build :provide_development_setup_bin
      build :setup_development_mail_delivery_strategy
      build :fix_i18n_deprecation_warning
      build :provide_generators_configuration
    end

    def setup_test_environment
      say "Setting up the test environment"
      build :init_rspec
      build :add_support_rspec_files
    end

    def setup_staging_environment
      say "Setting up the staging environment"
      build :copy_production_env_to_staging
    end

    def add_active_job_configuration
      say "Setting up ActiveJob with DelayedJob"
      build :init_delayed_job
      build :add_delayed_job_active_job_configuration
    end

    protected

      def get_builder_class
        Platter::AppBuilder
      end
  end
end
