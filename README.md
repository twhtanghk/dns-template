# dns-template
Generate configuration files from defined template and SRV record defined in DNS server or Consul.

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

The following is to cache @[servivce name] into srv variable and reference the first service node srv[0] IP to generate the nginx config file.
```
<% srv = @['oauth2.service.consul'] %>
location /org/ {
  proxy_pass http://<%- srv[0] %>:3000/;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Protocol $scheme;
  proxy_set_header X-Forwarded-Host $host;
}
```

## Start docker image as below
```
docker run -v ${PWD}/template:/usr/src/app/template --name config -d twhtanghk/dns-template
```

## Trigger configuration files generation
```
curl -X PUT http://dns-template.service.consul:1337/template/ect
```

* check template/dst folder for the generated config files
