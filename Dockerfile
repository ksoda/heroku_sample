FROM node:8 as node
FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential
ENV YARN_VERSION 1.6.0
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

ENV GOSU_URL https://github.com/tianon/gosu/releases/download/1.4/gosu
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN curl -o /usr/local/bin/gosu -SL "$GOSU_URL-$(dpkg --print-architecture)" \
 && rm -rf /var/lib/apt/lists/* \
 && chmod +x /usr/local/bin/gosu \
 && chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
