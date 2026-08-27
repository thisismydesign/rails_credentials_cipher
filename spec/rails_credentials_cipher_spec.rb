# frozen_string_literal: true

RSpec.describe RailsCredentialsCipher do
  let(:content) { "secret_key_base: abc123\n" }
  let(:out) { StringIO.new }

  before do
    encrypted_path, key_path = write_credentials(root, content)
    stub_rails(root, content_path: encrypted_path, key_path:)
    system('git', 'init', '-q', root.to_s)
    root.join('.gitignore').write("/config/master.key\n/config/credentials.yml\n")
  end

  it 'has a version number' do
    expect(RailsCredentialsCipher::VERSION).not_to be_nil
  end

  describe '.decrypt' do
    it 'decrypts the credentials the application uses and says where' do
      expect(described_class.decrypt(out:)).to eq(root.join('config/credentials.yml'))
      expect(root.join('config/credentials.yml').read).to eq(content)
      expect(out.string).to eq("Decrypted config/credentials.yml.enc to config/credentials.yml\n")
    end

    it 'warns when the plain file is not ignored by git' do
      root.join('.gitignore').write("/config/master.key\n")

      described_class.decrypt(out:)

      expect(out.string).to include('Warning: config/credentials.yml is not ignored by git')
    end

    it 'does not warn outside a git repository' do
      FileUtils.rm_rf(root.join('.git'))

      described_class.decrypt(out:)

      expect(out.string).not_to include('Warning')
    end

    it 'decrypts one environment with its own key' do
      encrypted_path, = write_credentials(root, 'env: production', name: 'credentials/production',
                                                                   key_name: 'credentials/production.key')

      expect(described_class.decrypt(environment: 'production', out:)).to eq(encrypted_path.sub_ext(''))
      expect(root.join('config/credentials/production.yml').read).to eq('env: production')
      expect(out.string)
        .to include('Decrypted config/credentials/production.yml.enc to config/credentials/production.yml')
    end

    it 'falls back to the master key for an environment without its own' do
      write_credentials(root, 'env: staging', name: 'credentials/staging')

      described_class.decrypt(environment: 'staging', out:)

      expect(root.join('config/credentials/staging.yml').read).to eq('env: staging')
    end
  end

  describe '.encrypt' do
    it 'encrypts the plain file back and says where' do
      root.join('config/credentials.yml').write('edited: true')

      expect(described_class.encrypt(out:)).to eq(root.join('config/credentials.yml.enc'))
      expect(read_credentials(root.join('config/credentials.yml.enc'), root.join('config/master.key')))
        .to eq('edited: true')
      expect(out.string).to eq("Encrypted config/credentials.yml to config/credentials.yml.enc\n")
    end

    it 'says when there is nothing to do' do
      described_class.decrypt(out: StringIO.new)

      described_class.encrypt(out:)

      expect(out.string).to eq("config/credentials.yml.enc already matches config/credentials.yml, nothing to do\n")
    end

    it 'encrypts one environment' do
      write_credentials(root, 'env: production', name: 'credentials/production', key_name: 'credentials/production.key')
      root.join('config/credentials/production.yml').write('env: edited')

      described_class.encrypt(environment: 'production', out:)

      expect(read_credentials(root.join('config/credentials/production.yml.enc'),
                              root.join('config/credentials/production.key'))).to eq('env: edited')
    end
  end
end
