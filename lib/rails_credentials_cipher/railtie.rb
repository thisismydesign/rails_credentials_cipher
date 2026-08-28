# frozen_string_literal: true

module RailsCredentialsCipher
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/credentials.rake', File.dirname(__FILE__))
    end
  end
end
