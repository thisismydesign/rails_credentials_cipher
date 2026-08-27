# frozen_string_literal: true

require 'pathname'
require 'active_support'
require 'active_support/encrypted_file'

module RailsCredentialsCipher
  # Moves one encrypted file between its encrypted form (`config/credentials.yml.enc`)
  # and a plain file next to it (`config/credentials.yml`), using the same
  # ActiveSupport::EncryptedFile that Rails reads the credentials with.
  class Cipher
    attr_reader :encrypted_path, :key_path, :env_key, :plain_path

    def initialize(encrypted_path:, key_path:, env_key: 'RAILS_MASTER_KEY', plain_path: nil)
      @encrypted_path = Pathname(encrypted_path)
      @key_path = Pathname(key_path)
      @env_key = env_key
      @plain_path = plain_path ? Pathname(plain_path) : default_plain_path
    end

    # Writes the decrypted content to the plain path. Returns the plain path.
    def decrypt
      plain_path.binwrite(encrypted_file.read)
      plain_path
    end

    # Encrypts the plain file over the encrypted path. Returns the encrypted
    # path when it was rewritten and nil when the content was already the same,
    # so an unchanged file does not get a new ciphertext.
    def encrypt
      raise Error, "#{plain_path} does not exist, decrypt first" unless plain_path.exist?

      contents = plain_path.binread
      return if unchanged?(contents)

      encrypted_file.write(contents)
      encrypted_path
    end

    private

    def default_plain_path
      unless encrypted_path.extname == '.enc'
        raise Error,
              "cannot derive a plain path from #{encrypted_path}, pass plain_path:"
      end

      encrypted_path.sub_ext('')
    end

    def unchanged?(contents)
      encrypted_path.exist? && encrypted_file.read == contents
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      false
    end

    def encrypted_file
      @encrypted_file ||= ActiveSupport::EncryptedFile.new(
        content_path: encrypted_path,
        key_path: key_path,
        env_key: env_key,
        raise_if_missing_key: true
      )
    end
  end
end
