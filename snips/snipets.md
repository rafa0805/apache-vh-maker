# Redirect HTTP to HTTPS
```
# global, htaccess
RewriteEngine on
RewriteCond %{SERVER_NAME} =hoiku.jobtoru.com
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
```

# Process tuning example
```
<IfModule prefork.c>
  StartServers 256
  MinSpareServers 256
  MaxSpareServers 8196
  ServerLimit 8196
  MaxClients 8196
  MaxConnectionsPerChild 10000
  # MaxRequestsPerChild 10000 --- old name for MaxConnectionsPerChild
</IfModule>

```
