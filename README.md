# dns-template
Generating configuration files from defined template files and SRV record defined in DNS server or Consul.

## ECT Template
Create directory (e.g. template/) and config file in [*.ect](http://ectjs.com) format

* template/config.coffee with dns server ip, service defined in DNS
```
module.exports =
  dns: '172.17.0.1'
  service: [
    'oauth2.service.consul'
  ]
```

* template/src/**/*.ect
The following is to cache @[servivce name] into srv variable and reference the first service node srv[0].name and .port to generate the nginx config file.
```
<% srv = @['oauth2.service.consul'] %>
location /org/ {
  proxy_pass http://<%- srv[0].name %>:<%- srv[0].port %>/;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Scheme $scheme;
  proxy_connect_timeout 1;
  proxy_send_timeout 30;
  proxy_read_timeout 30;
}
```

## start docker image as below
```
docker run -v ${PWD}/template:/usr/src/app/template --name config -d twhtanghk/dns-template
```

## URL to trigger re-generating configuration files into 'template/dst' folder
* check IP of the running image
```
docker inspect config
```

* trigger re-generating configuration files
```
curl -X PUT http://172.17.0.2:1337/template/ect
```
