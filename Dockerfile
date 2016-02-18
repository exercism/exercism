FROM ruby:2.2.2

COPY Gemfile Gemfile.lock /exercism/

WORKDIR /exercism

RUN bundle install
