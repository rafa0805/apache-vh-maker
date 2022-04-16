# Requirements
- Commands required:
  - httpd
  - certbot
- Include path to be written to http.conf if not yet.
```
IncludeOptional conf.d/vhosts/*.conf
```
- To be created /etc/httpd/conf/.htpasswd

# Files (and directories) created on result of scripts
|Files|Description|
|---|---|
|/etc/httpd/conf.d/vhosts/*|configuration file of virtual hosts|
|/etc/httpd/conf/base_require.conf|common requirements to be applied to all virtual hosts|
|/etc/httpd/conf.d/vhosts/includes/ssl/*|configuration of SSL related files for each virtual hosts|
|/var/www/example.com/|domain root|
|/var/www/example.com/html/|document root|
|/var/www/example.com/logs/|logs directory for the virtual host|

# How to create a virtual host
下記順番で実行 (引数は適宜差し替える)

```
[STEP0 Add include path to http.conf]

IncludeOptional conf.d/vhosts/*.conf

[STEP1 Set up HTTP virtual host]
arg1: domain, arg2: user

./make1_vh.sh example.com example_user

[STEP2 Get Let's encrypt certification]
arg1: domain, arg2: email

./make2_letsencrypt.sh example.com example@mail.com

[STEP3 Set up HTTPS virtual host]
arg1: domain

./make3_set_ssl.sh example.com
```
