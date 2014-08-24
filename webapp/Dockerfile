FROM ruby:2.1.2
MAINTAINER Néstor Salceda <nestor.salceda@gmail.com>

ENV ARDUINO_DEVICE /dev/ttyACM0

RUN git clone git://github.com/nestorsalceda/bolt.git /opt/bolt
WORKDIR /opt/bolt/webapp
RUN bundle install

CMD ["/usr/local/bin/foreman", "start", "-d", "/opt/bolt/webapp"]
EXPOSE 9292
