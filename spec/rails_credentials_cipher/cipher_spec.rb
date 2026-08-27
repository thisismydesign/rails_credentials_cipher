# frozen_string_literal: true

CONTENT = "secret_key_base: abc123\nsmtp:\n  password: hunter2\n"
EDITED = "#{CONTENT}new_service:\n  token: t0k3n\n".freeze

RSpec.describe RailsCredentialsCipher::Cipher do
  let(:encrypted_path) { root.join('config/credentials.yml.enc') }
  let(:key_path) { root.join('config/master.key') }
  let(:cipher) { described_class.new(encrypted_path:, key_path:) }

  before { write_credentials(root, CONTENT) }

  describe '#plain_path' do
    it 'drops the .enc extension' do
      expect(cipher.plain_path).to eq(root.join('config/credentials.yml'))
    end

    it 'keeps environment credentials next to their encrypted file' do
      encrypted_path, key_path = write_credentials(root, CONTENT, name: 'credentials/production')
      cipher = described_class.new(encrypted_path:, key_path:)

      expect(cipher.plain_path).to eq(root.join('config/credentials/production.yml'))
    end

    it 'accepts an explicit plain path' do
      cipher = described_class.new(encrypted_path:, key_path:, plain_path: root.join('plain.yml'))

      expect(cipher.plain_path).to eq(root.join('plain.yml'))
    end

    it 'refuses to guess without a .enc extension' do
      expect { described_class.new(encrypted_path: root.join('config/credentials.yml'), key_path:) }
        .to raise_error(RailsCredentialsCipher::Error, /pass plain_path:/)
    end
  end

  describe '#decrypt' do
    it 'writes the decrypted content to the plain path' do
      expect(cipher.decrypt).to eq(root.join('config/credentials.yml'))
      expect(root.join('config/credentials.yml').read).to eq(CONTENT)
    end

    it 'takes the key from the environment over the key file' do
      env_key = ActiveSupport::EncryptedFile.generate_key
      encrypted_path, = write_credentials(root, CONTENT, name: 'env', key: env_key)
      cipher = described_class.new(encrypted_path:, key_path: root.join('config/missing.key'), env_key: 'TEST_KEY')

      begin
        ENV['TEST_KEY'] = env_key
        expect(cipher.decrypt.read).to eq(CONTENT)
      ensure
        ENV.delete('TEST_KEY')
      end
    end

    it 'fails without a key' do
      cipher = described_class.new(encrypted_path:, key_path: root.join('config/missing.key'), env_key: 'UNSET_KEY')

      expect { cipher.decrypt }.to raise_error(ActiveSupport::EncryptedFile::MissingKeyError)
    end

    it 'fails without an encrypted file' do
      cipher = described_class.new(encrypted_path: root.join('config/missing.yml.enc'), key_path:)

      expect { cipher.decrypt }.to raise_error(ActiveSupport::EncryptedFile::MissingContentError)
    end

    it 'fails with the wrong key' do
      other_key = key_path.dirname.join('other.key')
      other_key.write(ActiveSupport::EncryptedFile.generate_key)
      cipher = described_class.new(encrypted_path:, key_path: other_key)

      expect { cipher.decrypt }.to raise_error(ActiveSupport::MessageEncryptor::InvalidMessage)
    end
  end

  describe '#encrypt' do
    it 'encrypts the plain file so that Rails can read it back' do
      cipher.plain_path.write(EDITED)

      expect(cipher.encrypt).to eq(encrypted_path)
      expect(read_credentials(encrypted_path, key_path)).to eq(EDITED)
    end

    it 'round-trips through decrypt and encrypt unchanged' do
      cipher.decrypt
      cipher.plain_path.write(EDITED)
      cipher.encrypt

      expect(described_class.new(encrypted_path:, key_path:).decrypt.read).to eq(EDITED)
    end

    it 'leaves the encrypted file alone when the content did not change' do
      cipher.decrypt
      before = encrypted_path.read

      expect(cipher.encrypt).to be_nil
      expect(encrypted_path.read).to eq(before)
    end

    it 'creates the encrypted file when there is none yet' do
      encrypted_path = root.join('config/credentials/staging.yml.enc')
      encrypted_path.dirname.mkpath
      encrypted_path.sub_ext('').write(EDITED)
      cipher = described_class.new(encrypted_path:, key_path:)

      expect(cipher.encrypt).to eq(encrypted_path)
      expect(read_credentials(encrypted_path, key_path)).to eq(EDITED)
    end

    it 'fails when the plain file is missing' do
      expect { cipher.encrypt }.to raise_error(RailsCredentialsCipher::Error, /decrypt first/)
    end

    it 'fails without a key' do
      cipher.plain_path.write(EDITED)
      cipher = described_class.new(encrypted_path:, key_path: root.join('config/missing.key'), env_key: 'UNSET_KEY')

      expect { cipher.encrypt }.to raise_error(ActiveSupport::EncryptedFile::MissingKeyError)
    end
  end
end
