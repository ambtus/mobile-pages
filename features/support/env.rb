# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'cucumber/rails'
DatabaseCleaner.strategy = :transaction
