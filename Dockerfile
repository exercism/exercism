FROM ruby:2.1.5

RUN mkdir /exercism

WORKDIR /exercism

ADD Gemfile /exercism/Gemfile

RUN bundle install

ADD . /exercism
