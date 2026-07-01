# frozen_string_literal: true

namespace :lint do
  desc "Run the rubocop static code analyzer"
  task rubocop: :environment do
    exit 1 unless system "rubocop#{" -f github" if ENV["CI"].present?}"
  end

  namespace :rubocop do
    desc "Run the rubocop static code analyzer and apply fixes"
    task fix: :environment do
      exit 1 unless system "rubocop --autocorrect-all#{" -f github" if ENV["CI"].present?}"
    end
  end

  desc "Run herb linter"
  task herb: :environment do
    exit 1 unless system "node_modules/.bin/herb-lint app engines/*/app"
  end

  namespace :herb do
    desc "Run herb linter and apply fixes"
    task fix: :environment do
      exit 1 unless system "node_modules/.bin/herb-lint --fix app engines/*/app"
    end
  end

  desc "Run prettier linter"
  task prettier: :environment do
    exit 1 unless system "git ls-files -z '*.scss' '*.yml' '*.yaml' | xargs -0 node_modules/.bin/prettier --check"
  end

  namespace :prettier do
    desc "Run prettier linter and apply fixes"
    task fix: :environment do
      exit 1 unless system "git ls-files -z '*.scss' '*.yml' '*.yaml' | xargs -0 node_modules/.bin/prettier --write"
    end
  end

  desc "Run biome linter"
  task biome: :environment do
    exit 1 unless system "git ls-files -z '*.js' '*.ts' '*.json' | xargs -0 node_modules/.bin/biome ci"
  end

  namespace :biome do
    desc "Run biome linter and apply fixes"
    task fix: :environment do
      exit 1 unless system "git ls-files -z '*.js' '*.ts' '*.json' | xargs -0 node_modules/.bin/biome format --write"
      exit 1 unless system "git ls-files -z '*.js' '*.ts' '*.json' | xargs -0 node_modules/.bin/biome check --write --unsafe"
    end
  end

  task all: %i[rubocop herb prettier biome]
  namespace :all do
    task fix: %w[lint:rubocop:fix lint:herb:fix lint:prettier:fix lint:biome:fix]
  end
end
