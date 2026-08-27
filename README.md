# RailsCredentialsCipher

#### Decrypt, edit, and encrypt Rails credentials.

Rails keeps your credentials encrypted and only lets you change them through `bin/rails credentials:edit`, which opens them in a terminal editor. This gem lets you take them out as a plain file, edit that file with whatever you like — your IDE, a coding agent, a script — and encrypt it back.

## Installation

Add to your application's Gemfile:

```rb
gem "rails_credentials_cipher", group: :development
```

Then keep the decrypted files out of git:

```sh
bin/rails generate rails_credentials_cipher:install
```

## Usage

```sh
bin/rails credentials:decrypt    # config/credentials.yml.enc -> config/credentials.yml
# edit config/credentials.yml
bin/rails credentials:encrypt    # config/credentials.yml -> config/credentials.yml.enc
```

For per-environment credentials, pass the environment:

```sh
bin/rails credentials:decrypt[production]    # config/credentials/production.yml.enc -> config/credentials/production.yml
bin/rails credentials:encrypt[production]
```

The key is found the same way Rails finds it: `RAILS_MASTER_KEY`, `config/master.key`, or `config/credentials/production.key` for an environment. In zsh, quote the task: `bin/rails 'credentials:decrypt[production]'`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thisismydesign/rails_credentials_cipher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
