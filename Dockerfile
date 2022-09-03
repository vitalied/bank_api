FROM ruby:3.1.2-alpine

# Install requirements to run app
RUN apk add --no-cache --update \
                                git \
                                build-base \
                                postgresql-dev \
                                nodejs \
                                tzdata

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bundle", "exec", "bin/rails", "server", "-p", "3000", "-b", "0.0.0.0"]
