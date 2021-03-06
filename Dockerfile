FROM python:3
LABEL \
    name="CMSScan" \
    author="Ajin Abraham <ajin25@gmail.com>" \
    description="Scan Wordpress and Drupal CMS for Security issues"

WORKDIR /usr/src/app
RUN \
  apt-get update && \
  apt-get install -y ruby \
  ruby-dev \
  git
RUN gem install wpscan && \
  wpscan --update

COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN git submodule update --init --recursive
WORKDIR /usr/src/app/plugin/vbscan
RUN git pull origin master
WORKDIR /usr/src/app/plugin/joomscan
RUN git pull origin master

WORKDIR /usr/src/app
EXPOSE 7070

CMD ["gunicorn", "--bind", "0.0.0.0:7070", "app:app", "--workers", "3", "--timeout", "10000"]