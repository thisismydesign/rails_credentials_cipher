# RailsCredentialsCipher

@README.md

A gem that adds `credentials:decrypt` and `credentials:encrypt` rake tasks to Rails applications. Encryption is delegated to `ActiveSupport::EncryptedFile`, the class Rails itself reads credentials with.

## Instructions

- MUST keep all encryption in `ActiveSupport::EncryptedFile`. MUST NOT reimplement the cipher: anything Rails cannot read back is a bug.
- MUST keep the task names `credentials:decrypt` and `credentials:encrypt`; applications call them by name from their own docs.
- MUST keep `RailsCredentialsCipher::Cipher` free of Rails. Only the module-level methods and the Railtie MAY touch `Rails`.
- MUST NOT print or log decrypted content; messages name paths only.
- Specs MUST round-trip through a real `ActiveSupport::EncryptedFile` in a temporary directory, never a stub of it.
- Specs MUST NOT depend on a Rails application; `stub_rails` in `spec/spec_helper.rb` is the whole Rails surface the gem uses.
- The final result MUST pass `bundle exec rspec` and `bundle exec rubocop`. MUST NOT disable a cop without the reason next to it.
- SHOULD record what an agent would need next time in this file or in the skill it belongs to.

## Development

See: [dev-env](.claude/skills/dev-env/SKILL.md) for setup, test, lint, manual test and release.

## Architecture

- `lib/rails_credentials_cipher/cipher.rb` — one encrypted file and its plain twin; `decrypt`, `encrypt`, nothing Rails-specific.
- `lib/rails_credentials_cipher.rb` — resolves the paths from the Rails application or an environment argument, prints what happened, warns when the plain file is not git-ignored.
- `lib/rails_credentials_cipher/railtie.rb` and `lib/tasks/credentials.rake` — the rake surface; one line per task, logic stays in the module.
- `sig/rails_credentials_cipher.rbs` — MUST follow every public API change.
- `.github/workflows/release.yml` — publishes on a `v*` tag; the tag MUST equal `VERSION`.

## Code style

- Ruby `>= 3.3` (the oldest Ruby still maintained) up to 4.0 in CI: MUST NOT use syntax newer than 3.3. `TargetRubyVersion` is that minimum, on purpose below `.tool-versions`.
- `encrypt` returns the encrypted path or `nil` for "unchanged"; MUST NOT turn it into a boolean (RuboCop flags predicate-shaped names).
