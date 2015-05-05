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

    def add_api_support
      inject_into_file "Gemfile", after: "ruby \"#{Platter::RUBY_VERSION}\"" do
        %Q{

gem "versionist"
gem "active_model_serializers", github: "rails-api/active_model_serializers", branch: "0-8-stable"
        }
      end
    end

    def setup_git
      remove_file '.gitignore'
      copy_file "platter_gitignore", ".gitignore"
      run "git init"
    end

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
        },
          after: "config.action_mailer.raise_delivery_errors = false"
    end

  end
end
