module Platter
  class AppBuilder < Rails::AppBuilder

    def readme
      template "README.md.erb", "README.md"
    end

  end
end
