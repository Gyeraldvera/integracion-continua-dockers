#!/usr/bin/env bash

set -e

APPDIR="/app/"
APPNAME="tramite"

cd $APPDIR


if [ "$1" = 'uwsgi' ] || [ "${#}" -eq 0 ]; then
    echo -n "[INFO] Running 'python manage.py collectstatic'..."
    python manage.py collectstatic --no-input >/dev/null
    echo "[OK]"   
    ## custom command 
    ##python manage.py makemigrations --merge
    echo -n "[INFO] Running 'python manage.py migrate'..."
   
    python manage.py  makemigrations formality
    python manage.py  makemigrations entity
    python manage.py  makemigrations civil_servant
    python manage.py  makemigrations attachment
    python manage.py migrate

    echo "runserver working"
    ## start uWSGI
    uwsgi --master --http 0.0.0.0:8000 --chdir /app/ --wsgi-file /app/tramite/wsgi.py \
     --static-map /static/=/app/static/ --static-map /media/=/app/media/           \
     --uid django --gid django --processes 5
else
    exec "$@"
fi


