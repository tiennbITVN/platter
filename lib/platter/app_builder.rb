module Platter
  class AppBuilder < Rails::AppBuilder

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

  end
end
