# RailsCredentialsCipher

#### Decrypt, edit, and encrypt Rails credentials.

`bin/rails credentials:edit` opens the decrypted credentials in `$EDITOR` and seals them again when the editor closes. That works at a terminal and nowhere else — not from a coding agent, an IDE, or a script. This gem adds two rake tasks that put the decrypted YAML on disk as a plain file and encrypt it again when you are done, using the same `ActiveSupport::EncryptedFile` Rails reads the credentials with.

## Installation

Add to your application's Gemfile:

```rb
gem "rails_credentials_cipher", group: :development
```

## Usage

```sh
bin/rails credentials:decrypt    # config/credentials.yml.enc -> config/credentials.yml
# edit config/credentials.yml
bin/rails credentials:encrypt    # config/credentials.yml -> config/credentials.yml.enc
```

The key is the one Rails would use: `RAILS_MASTER_KEY` when set, otherwise `config/master.key`. The encrypted file is only rewritten when the content changed, so an untouched file does not get a new ciphertext.

Keep the plain file out of git. `credentials:decrypt` warns when it is not ignored:

```gitignore
/config/credentials.yml
/config/credentials/*.yml
```

### Per-environment credentials

Pass the environment to work on `config/credentials/<environment>.yml.enc`:

```sh
bin/rails credentials:decrypt[production]    # -> config/credentials/production.yml
bin/rails credentials:encrypt[production]
```

The key is `config/credentials/<environment>.key`, falling back to `config/master.key` as Rails does. In zsh, quote the task: `bin/rails 'credentials:decrypt[production]'`.

Without an argument the tasks use the credentials of the current `RAILS_ENV`, resolved exactly as `Rails.application.credentials` resolves them, including a `config.credentials.content_path` or `key_path` override.

### Tasks

| Task                               | From                                        | To                                          |
| ---------------------------------- | ------------------------------------------- | ------------------------------------------- |
| `credentials:decrypt`              | `config/credentials.yml.enc`                | `config/credentials.yml`                    |
| `credentials:encrypt`              | `config/credentials.yml`                    | `config/credentials.yml.enc`                |
| `credentials:decrypt[environment]` | `config/credentials/<environment>.yml.enc`  | `config/credentials/<environment>.yml`      |
| `credentials:encrypt[environment]` | `config/credentials/<environment>.yml`      | `config/credentials/<environment>.yml.enc`  |

### Ruby API

Any encrypted file Rails can read, not only the credentials:

```rb
cipher = RailsCredentialsCipher::Cipher.new(
  encrypted_path: "config/credentials.yml.enc",
  key_path: "config/master.key",
  env_key: "RAILS_MASTER_KEY",       # default; wins over key_path when set
  plain_path: nil                    # default: encrypted_path without .enc
)

cipher.decrypt    # => #<Pathname:config/credentials.yml>
cipher.encrypt    # => #<Pathname:config/credentials.yml.enc>, or nil when nothing changed
```

`RailsCredentialsCipher.decrypt(environment: nil)` and `.encrypt(environment: nil)` are what the tasks call: they resolve the paths from the running application and print what they did.

## Links

- [rails_credentials_cipher on RubyGems](https://rubygems.org/gems/rails_credentials_cipher)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thisismydesign/rails_credentials_cipher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
