source "https://rubygems.org"

ruby "2.1.2"

gem "rails", "4.1.0"

gem "aws-sdk"
gem "bcrypt", "~> 3.1.7"
gem "micromachine"
gem "pg"

gem "coffee-rails"
gem "sass-rails"
gem "therubyracer",  platforms: :ruby
gem "uglifier"

gem "puma"

group :development do
  gem "spring"
end

group :development, :test do
  gem "database_cleaner"
  gem "dotenv-rails"
  gem "factories"
  gem "pry"
  gem "rspec-rails"
end

group :test do
  gem "simplecov"
end

group :production do
  gem "rails_12factor"
end
