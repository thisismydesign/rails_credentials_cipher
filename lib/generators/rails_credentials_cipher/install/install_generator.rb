# frozen_string_literal: true

require 'rails/generators'

module RailsCredentialsCipher
  module Generators
    # bin/rails generate rails_credentials_cipher:install
    class InstallGenerator < Rails::Generators::Base
      desc 'Adds the decrypted credentials files to .gitignore'

      IGNORES = ['/config/credentials.yml', '/config/credentials/*.yml'].freeze

      def ignore_decrypted_credentials
        missing = IGNORES.reject { |pattern| ignored?(pattern) }
        return say_status :identical, '.gitignore already ignores the decrypted credentials', :blue if missing.empty?

        lines = "# Decrypted credentials, see rails_credentials_cipher\n#{missing.join("\n")}\n"
        if File.exist?(gitignore_path)
          append_to_file '.gitignore', "\n#{lines}"
        else
          create_file '.gitignore', lines
        end
      end

      private

      def gitignore_path
        File.join(destination_root, '.gitignore')
      end

      # A pattern with or without the leading slash covers the same file at the root.
      def ignored?(pattern)
        return false unless File.exist?(gitignore_path)

        File.readlines(gitignore_path, chomp: true).map { |line| line.strip.delete_prefix('/') }
            .include?(pattern.delete_prefix('/'))
      end
    end
  end
end
