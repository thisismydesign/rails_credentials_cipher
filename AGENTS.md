# RailsCredentialsCipher

@README.md

A gem that adds `credentials:decrypt` and `credentials:encrypt` rake tasks to Rails applications.

## Instructions

- MUST pass `bundle exec rspec`, `bundle exec rubocop` and `bundle exec steep check` before finishing. MUST NOT disable a cop or a Steep diagnostic without the reason next to it.
- MUST NOT print or log decrypted content; messages name paths only.
- Specs MUST NOT need a Rails application; `stub_rails` in `spec/spec_helper.rb` stands in for it.
- `sig/rails_credentials_cipher.rbs` types the gem and `sig/external/` the slice of Rails it calls; Steep checks `lib/` against both, so a method is not done until its signature is. `sig/external/` is not shipped with the gem.
- Ruby floor is the oldest version still maintained (3.3): `required_ruby_version`, `TargetRubyVersion` and the CI matrix move together, and `TargetRubyVersion` stays below `.tool-versions` on purpose.

## Development

```sh
mise install && bin/setup                 # Ruby from .tool-versions, then bundle install
bundle exec rspec                         # tests; add a path or path:line for one file or example
bundle exec rubocop -A                    # lint with auto-fix, RBS files included
bundle exec steep check                   # types: lib/ against sig/
bundle exec bundler-audit check --update  # dependency audit
```

To try it in a Rails application, add `gem "rails_credentials_cipher", path: "../rails_credentials_cipher", group: :development` to its Gemfile and run `bin/rails credentials:decrypt` there with its `config/master.key` present.

Release: bump `lib/rails_credentials_cipher/version.rb`, `bundle install` so `Gemfile.lock` follows, commit, then `bundle exec rake release`.
