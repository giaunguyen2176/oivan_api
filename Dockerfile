FROM ruby:3.1.2

WORKDIR /src

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
    
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Cache bundle install & yarn install earlier in the process, so it does not rebuild every source change
COPY Gemfile* ./

RUN gem install bundler
RUN bundle install

COPY . ./

RUN chmod a+x *.sh

EXPOSE 3000
