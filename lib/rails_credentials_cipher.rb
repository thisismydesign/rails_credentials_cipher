# frozen_string_literal: true

require 'English'
require_relative 'rails_credentials_cipher/version'
require_relative 'rails_credentials_cipher/cipher'
require_relative 'rails_credentials_cipher/railtie' if defined?(Rails::Railtie)

module RailsCredentialsCipher
  class Error < StandardError; end

  class << self
    # Decrypts the application's credentials into a plain file next to the
    # encrypted one, and warns when that file is not ignored by git.
    def decrypt(environment: nil, out: $stdout)
      cipher = cipher(environment:)
      cipher.decrypt
      out.puts "Decrypted #{relative(cipher.encrypted_path)} to #{relative(cipher.plain_path)}"
      out.puts "Warning: #{relative(cipher.plain_path)} is not ignored by git" if git_tracked?(cipher.plain_path)
      cipher.plain_path
    end

    # Encrypts the plain file back over the application's credentials.
    def encrypt(environment: nil, out: $stdout)
      cipher = cipher(environment:)
      if cipher.encrypt
        out.puts "Encrypted #{relative(cipher.plain_path)} to #{relative(cipher.encrypted_path)}"
      else
        out.puts "#{relative(cipher.encrypted_path)} already matches #{relative(cipher.plain_path)}, nothing to do"
      end
      cipher.encrypted_path
    end

    # The cipher for the credentials the running application would use, or for
    # the given environment's `config/credentials/<environment>.yml.enc`. The key
    # falls back from `config/credentials/<environment>.key` to `config/master.key`
    # the way Rails does; `RAILS_MASTER_KEY` wins over both.
    def cipher(environment: nil)
      Cipher.new(**paths(environment:))
    end

    private

    def paths(environment:)
      return app_paths unless environment

      key_path = Rails.root.join("config/credentials/#{environment}.key")
      key_path = Rails.root.join('config/master.key') unless key_path.exist?
      { encrypted_path: Rails.root.join("config/credentials/#{environment}.yml.enc"), key_path: }
    end

    def app_paths
      config = Rails.application.config.credentials
      { encrypted_path: Rails.root.join(config.content_path), key_path: Rails.root.join(config.key_path) }
    end

    def relative(path)
      path.relative_path_from(Rails.root)
    end

    # True only when git says the file is not ignored; a missing git or a
    # directory outside any repository is not a reason to warn.
    def git_tracked?(path)
      system('git', 'check-ignore', '-q', path.to_s, chdir: Rails.root.to_s, out: File::NULL, err: File::NULL)
      $CHILD_STATUS&.exitstatus == 1
    end
  end
end
