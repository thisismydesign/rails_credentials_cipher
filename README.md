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

This adds to `.gitignore`:

```gitignore
/config/credentials.yml
/config/credentials/*.yml
```

## Usage

```sh
bin/rails credentials:decrypt    # config/credentials.yml.enc -> config/credentials.yml
# edit config/credentials.yml
bin/rails credentials:encrypt    # config/credentials.yml -> config/credentials.yml.enc
```

For per-environment credentials, add the environment:

```sh
bin/rails credentials:decrypt:production    # config/credentials/production.yml.enc -> config/credentials/production.yml
bin/rails credentials:encrypt:production
```

## Development

```sh
mise install && bin/setup     # Ruby from .tool-versions, then bundle install
bundle exec rspec             # tests
bundle exec rubocop -A        # lint with auto-fix
bundle exec steep check       # types: lib/ against sig/
```

To try it in a Rails application, point its Gemfile at your checkout and run the tasks there:

```rb
gem "rails_credentials_cipher", path: "../rails_credentials_cipher", group: :development
```

To release, bump the version in `lib/rails_credentials_cipher/version.rb`, run `bundle install` so `Gemfile.lock` follows, commit, then:

```sh
bundle exec rake release      # tags v<version>, pushes the commits and the tag, pushes the gem to rubygems.org
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thisismydesign/rails_credentials_cipher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
