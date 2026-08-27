---
name: dev-env
description: Set up and run the project locally — install, run, test, lint. Read this before running anything in the repo.
---

<!-- cto:universal:start id=dev-env -->

# Development Environment

## Standard

- Toolchain versions MUST come from `mise` via a checked-in `.tool-versions` (or `mise.toml`). No manual runtime installs.
- The app MUST run natively on the host. Docker is for backing services (database, queue, object storage) only.
- Devcontainers MUST NOT be the documented path. See [docs/best-practices.md](../../docs/best-practices.md) in the CTO repo for the rationale.
- Secrets MUST come from a `.env` copied from a committed `.env.example`; the example MUST list every variable with a safe placeholder.
- Every command below MUST be runnable from a fresh clone in the order given.

## Sections this skill MUST document for the project

Keep each to its commands, in the project-specific section below:

- **Setup** — prerequisites, then the exact commands from clone to running app.
- **Run** — starting the app, and the local URL.
- **Test** — whole suite, single file, single test.
- **Lint** — with auto-fix.
- **Manual test** — URL and credentials, or the CLI invocation that proves it works.

<!-- cto:universal:end -->

## Project specifics

A gem, not an app: there is nothing to run or serve. Ruby comes from `.tool-versions`; there is no `.env`.

### Setup

```sh
mise install
bin/setup
```

### Run

```sh
bin/console    # IRB with the gem loaded
```

To try the rake tasks, point a Rails application at this checkout in its Gemfile and run them there:

```rb
gem "rails_credentials_cipher", path: "../rails_credentials_cipher", group: :development
```

### Test

```sh
bundle exec rspec                                                   # whole suite
bundle exec rspec spec/rails_credentials_cipher/cipher_spec.rb      # one file
bundle exec rspec spec/rails_credentials_cipher/cipher_spec.rb:38   # one example
```

### Lint

```sh
bundle exec rubocop -A
```

### Manual test

In a Rails application using this checkout, with its `config/master.key` present:

```sh
bin/rails credentials:decrypt          # writes config/credentials.yml
# edit config/credentials.yml
bin/rails credentials:encrypt          # rewrites config/credentials.yml.enc
bin/rails credentials:show             # Rails reads the edit back
```

### Release

1. Bump `lib/rails_credentials_cipher/version.rb`, run `bundle install` so `Gemfile.lock` follows, commit.
2. Tag and push: `git tag v<version> && git push origin main v<version>`.
3. The `Release` workflow checks the tag against the version and publishes to RubyGems through trusted publishing (`rubygems/release-gem`, `release` environment). The trusted publisher is configured once on rubygems.org for this repository.
