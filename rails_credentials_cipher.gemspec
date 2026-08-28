# frozen_string_literal: true

require_relative 'lib/rails_credentials_cipher/version'

Gem::Specification.new do |spec|
  spec.name = 'rails_credentials_cipher'
  spec.version = RailsCredentialsCipher::VERSION
  spec.authors = ['thisismydesign']
  spec.email = ['git.thisismydesign@gmail.com']

  spec.summary = 'Decrypt, edit, and encrypt Rails credentials.'
  spec.homepage = 'https://github.com/thisismydesign/rails_credentials_cipher'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/thisismydesign/rails_credentials_cipher'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ sig/external/ .git .github appveyor Gemfile Steepfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'railties', '>= 7.1'
end
