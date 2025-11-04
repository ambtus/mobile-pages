# frozen_string_literal: true

def load_helpers = Rails.root.glob('test_helpers/helper_files/*.rb').each { |f| require f }
