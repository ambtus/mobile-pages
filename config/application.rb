# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MobilePages
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.autoload_paths += Dir["#{config.root}/app/models/*"]

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Generating image variants require the image_processing gem. Please add `gem "image_processing", "~> 1.2"` to your Gemfile or set:
    config.active_storage.variant_processor = :disabled

    where =
      if ENV['LOUD'].present?
        $stdout
      elsif Rails.env.test?
        '/tmp/mp_test.log'
      elsif Rails.env.development?
        '/tmp/mp_development.log'
      elsif Rails.env.production?
        'log/production.log'
      else
        raise 'where do you want the logs to go?'
      end

    my_formatting = proc do |severity, _datetime, _progname, msg|
      # Find the calling file and line number
      call_stack = caller
      # Loop through the call stack until we find a file within the Rails app's root directory
      file_and_line = call_stack.find { |path| path.include?(Rails.root.to_s) }
      if file_and_line
        # Extract the file path and line number
        file_and_line_info = file_and_line.split(':')
        #      file_name = File.basename(file_and_line_info[0])
        file_name = file_and_line_info[0].delete_prefix(Rails.root.to_s).chip
        line_number = file_and_line_info[1]
        prefix = "[#{severity}] [#{file_name}:#{line_number}]"
      else
        prefix = "[#{severity}]"
      end

      # Return the formatted message
      "#{prefix} #{msg}\n"
    end

    config.logger = ActiveSupport::Logger.new(where)
                                         .tap { |logger| logger.formatter = my_formatting }
    # .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  end
end
