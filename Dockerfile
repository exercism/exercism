FROM ruby:2.3.3

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
  apt-get install -y nodejs postgresql-client && \
  npm install -g lineman

COPY Gemfile Gemfile.lock /exercism/

WORKDIR /exercism

RUN bundle install
