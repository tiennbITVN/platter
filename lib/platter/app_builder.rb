module Platter
  class AppBuilder < Rails::AppBuilder

    def readme
      template "README.md.erb", "README.md"
    end

    def replace_gemfile
      remove_file "Gemfile"
      template "Gemfile.erb", "Gemfile"
    end

  end
end
