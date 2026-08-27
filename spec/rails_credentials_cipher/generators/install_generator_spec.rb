# frozen_string_literal: true

require 'generators/rails_credentials_cipher/install/install_generator'

RSpec.describe RailsCredentialsCipher::Generators::InstallGenerator do
  let(:gitignore) { root.join('.gitignore') }

  def run_generator
    described_class.start(['--quiet'], destination_root: root.to_s)
  end

  it 'creates .gitignore with both patterns when there is none' do
    run_generator

    expect(gitignore.read).to eq(<<~GITIGNORE)
      # Decrypted credentials, see rails_credentials_cipher
      /config/credentials.yml
      /config/credentials/*.yml
    GITIGNORE
  end

  it 'appends only the missing patterns, treating a leading slash as optional' do
    gitignore.write("/config/master.key\nconfig/credentials.yml\n")

    run_generator

    expect(gitignore.read).to eq(<<~GITIGNORE)
      /config/master.key
      config/credentials.yml

      # Decrypted credentials, see rails_credentials_cipher
      /config/credentials/*.yml
    GITIGNORE
  end

  it 'leaves a complete .gitignore alone' do
    run_generator
    before = gitignore.read

    run_generator

    expect(gitignore.read).to eq(before)
  end
end
