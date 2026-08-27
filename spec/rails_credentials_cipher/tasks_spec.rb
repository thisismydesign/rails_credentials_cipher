# frozen_string_literal: true

require 'rake'

RSpec.describe 'credentials rake tasks' do # rubocop:disable RSpec/DescribeClass -- rake tasks have no class
  let(:rake) { Rake::Application.new }

  before do
    encrypted_path, key_path = write_credentials(root, "from: rake\n")
    stub_rails(root, content_path: encrypted_path, key_path:)
    Rake.application = rake
    Rake::TaskManager.record_task_metadata = true
    rake.define_task(Rake::Task, :environment)
    load File.expand_path('../../lib/tasks/credentials.rake', __dir__)
  end

  it 'defines both tasks with descriptions' do
    expect(rake['credentials:decrypt'].comment).to start_with('Decrypt')
    expect(rake['credentials:encrypt'].comment).to start_with('Encrypt')
  end

  it 'decrypts and encrypts through the module' do
    expect { rake['credentials:decrypt'].invoke }.to output(/Decrypted/).to_stdout
    root.join('config/credentials.yml').write("from: file\n")
    expect { rake['credentials:encrypt'].invoke }.to output(/Encrypted/).to_stdout

    expect(read_credentials(root.join('config/credentials.yml.enc'), root.join('config/master.key')))
      .to eq("from: file\n")
  end

  it 'stops with the explanation instead of a stack trace' do
    root.join('config/master.key').delete

    expect { rake['credentials:decrypt'].invoke }
      .to raise_error(SystemExit).and output(%r{set RAILS_MASTER_KEY or write it to config/master.key}).to_stderr
  end

  it 'passes the environment argument through' do
    allow(RailsCredentialsCipher).to receive(:decrypt)

    rake['credentials:decrypt'].invoke('production')

    expect(RailsCredentialsCipher).to have_received(:decrypt).with(environment: 'production')
  end
end
