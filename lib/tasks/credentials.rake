# frozen_string_literal: true

namespace :credentials do
  desc 'Decrypt the credentials into a plain file for editing, e.g. credentials:decrypt[production]'
  task :decrypt, [:environment] => :environment do |_task, args|
    RailsCredentialsCipher.decrypt(environment: args[:environment])
  end

  desc 'Encrypt the plain file back over the credentials, e.g. credentials:encrypt[production]'
  task :encrypt, [:environment] => :environment do |_task, args|
    RailsCredentialsCipher.encrypt(environment: args[:environment])
  end
end
