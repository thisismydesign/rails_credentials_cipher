# frozen_string_literal: true

# Stops with the explanation instead of a stack trace.
abort_on_error = lambda do |&work|
  work.call
rescue RailsCredentialsCipher::Error => e
  abort e.message
end

namespace :credentials do
  desc 'Decrypt the credentials into a plain file for editing'
  task decrypt: :environment do
    abort_on_error.call { RailsCredentialsCipher.decrypt }
  end

  desc 'Encrypt the plain file back over the credentials'
  task encrypt: :environment do
    abort_on_error.call { RailsCredentialsCipher.encrypt }
  end

  RailsCredentialsCipher.environments.each do |env|
    namespace :decrypt do
      desc "Decrypt config/credentials/#{env}.yml.enc into a plain file for editing"
      task env => :environment do
        abort_on_error.call { RailsCredentialsCipher.decrypt(environment: env) }
      end
    end

    namespace :encrypt do
      desc "Encrypt the plain file back over config/credentials/#{env}.yml.enc"
      task env => :environment do
        abort_on_error.call { RailsCredentialsCipher.encrypt(environment: env) }
      end
    end
  end
end
