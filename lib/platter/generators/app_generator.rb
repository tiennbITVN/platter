require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Platter
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    class_option :skip_turbolinks, type: :boolean, default: true,
      desc: "Skips the turbolinks gem"

    def finish_template
      invoke :platter
      super
    end

    def platter
    end

    protected

      def get_builder_class
        Platter::AppBuilder
      end
  end
end
