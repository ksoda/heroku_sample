FROM node:8 as node
FROM ruby:2.5
ENV WORKSPACE=/usr/local/src

RUN apt-get update -qq && apt-get install -y build-essential
COPY --from=node /opt/yarn-v* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

RUN groupadd -r --gid 1000 rails && \
    useradd -m -r --uid 1000 --gid 1000 rails

RUN mkdir -p $WORKSPACE $BUNDLE_APP_CONFIG && \
    chown -R rails:rails $WORKSPACE && \
    chown -R rails:rails $BUNDLE_APP_CONFIG

USER rails
WORKDIR $WORKSPACE

COPY --chown=rails:rails Gemfile Gemfile.lock $WORKSPACE/
RUN bundle install
COPY --chown=rails:rails . .
