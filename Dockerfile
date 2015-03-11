FROM ruby:2.1.5

RUN mkdir /exercism

WORKDIR /exercism

ADD Gemfile /exercism/Gemfile

ADD Gemfile.lock /exercism/Gemfile.lock

RUN bundle install
