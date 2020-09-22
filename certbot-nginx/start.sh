echo  "----------------------------------------------------------------"
echo  "Starting nginx and lets encrypt setup using"
echo  "Domain : $MY_DOMAIN_NAME"
echo  "Email  : $EMAIL_ADDRESS"
echo  "----------------------------------------------------------------"
_args=""
_server_names=""
if [ "x${MY_DOMAIN_NAME}" != "x" ]; then
    _args=" -d ${MY_DOMAIN_NAME} -d www.${MY_DOMAIN_NAME}"
    _server_names="${MY_DOMAIN_NAME} www.${MY_DOMAIN_NAME} "
fi
if [ "x${MY_DOMAIN_NAMES}" != "x" ]; then
    for domain in $MY_DOMAIN_NAMES; do
        _args="${_args} -d ${domain}"
        _server_names="${_server_names} ${domain}"
    done
fi
sed -i "s/___server_names___/$_server_names/g" /etc/nginx/nginx.conf
nginx
sleep 5
./certbot-auto --nginx ${_args} --text --agree-tos --no-self-upgrade --no-redirect --email $EMAIL_ADDRESS -v -n
nginx -s stop
sleep 3
nginx -g "daemon off;"
