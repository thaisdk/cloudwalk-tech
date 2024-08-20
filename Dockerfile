FROM ruby:3.3.4

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile

COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

RUN chmod u+x bin/rails

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
