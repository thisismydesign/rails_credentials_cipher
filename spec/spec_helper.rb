# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'tmpdir'
require 'rails_credentials_cipher'

RSpec.shared_context 'with a temporary root' do
  let(:root) { Pathname(Dir.mktmpdir('rails_credentials_cipher')) }

  after { root.rmtree }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include_context 'with a temporary root'
end

# Writes a Rails-compatible key and encrypted file under root and returns their paths.
def write_credentials(root, content, name: 'credentials', key_name: 'master.key', key: nil)
  key ||= ActiveSupport::EncryptedFile.generate_key
  key_path = root.join('config', key_name)
  encrypted_path = root.join('config', "#{name}.yml.enc")
  key_path.dirname.mkpath
  encrypted_path.dirname.mkpath
  key_path.write(key)
  ActiveSupport::EncryptedFile.new(
    content_path: encrypted_path, key_path: key_path, env_key: 'UNUSED', raise_if_missing_key: true
  ).write(content)
  [encrypted_path, key_path]
end

def read_credentials(encrypted_path, key_path)
  ActiveSupport::EncryptedFile.new(
    content_path: encrypted_path, key_path: key_path, env_key: 'UNUSED', raise_if_missing_key: true
  ).read
end

# A stand-in for the parts of Rails the gem touches: root, application.config.credentials.
def stub_rails(root, content_path:, key_path:)
  credentials = Struct.new(:content_path, :key_path).new(content_path, key_path)
  config = Struct.new(:credentials).new(credentials)
  application = Struct.new(:config).new(config)
  stub_const('Rails', Struct.new(:root, :application).new(root, application))
end
