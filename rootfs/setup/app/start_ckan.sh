#!/bin/bash
# Run the prerun script to init CKAN and create the default admin user
python prerun.py

# Set the common uwsgi options
UWSGI_OPTS="--socket /tmp/uwsgi.sock --uid 92 --gid 92 --http :4000 --master --enable-threads --paste config:/srv/app/production.ini --lazy-apps --gevent 2000 -p 4"

# Check whether http basic auth password protection is enabled and enable basicauth routing on uwsgi respecfully
if [ $? -eq 0 ]
then
  if [ "$PASSWORD_PROTECT" = true ]
  then
    if [ "$HTPASSWD_USER" ] || [ "$HTPASSWD_PASSWORD" ]
    then
      # Generate htpasswd file for basicauth
      htpasswd -d -b -c /srv/app/.htpasswd $HTPASSWD_USER $HTPASSWD_PASSWORD
      # Start Varnish
      varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:5000
      # Start uwsgi with basicauth
      uwsgi --ini /srv/app/uwsgi.conf --pcre-jit $UWSGI_OPTS
    else
      echo "Missing HTPASSWD_USER or HTPASSWD_PASSWORD environment variables. Exiting..."
      exit 1
    fi
  else
    # Start Varnish
    varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:5000
    # Start uwsgi
    uwsgi $UWSGI_OPTS
  fi
else
  echo "[prerun] failed...not starting CKAN."
fi