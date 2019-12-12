echo  "----------------------------------------------------------------"
echo  "Starting nginx and lets encrypt setup using"
echo  "Domain : $MY_DOMAIN_NAME"
echo  "Email  : $EMAIL_ADDRESS"
echo  "----------------------------------------------------------------"
sed -i "s/___my.example.com___/$MY_DOMAIN_NAME/g" /etc/nginx/nginx.conf
nginx
sleep 5
./certbot-auto --nginx -d $MY_DOMAIN_NAME -d www.$MY_DOMAIN_NAME --text --agree-tos --no-self-upgrade --no-redirect --email $EMAIL_ADDRESS -v -n
nginx -s stop
sleep 3
nginx -g "daemon off;"
