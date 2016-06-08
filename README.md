# dns-template
Generate configuration files from defined template and SRV record defined in DNS server or Consul.

## ECT Template
Create directory (e.g. template/) and config file

* template/config.coffee with dns server ip, service defined in DNS
```
module.exports =
  dns: '172.17.0.1'
  service: [
    'oauth2.service.consul'
    'mobile.service.consul'
  ]
```

* template/src/**/*.ect in [*.ect](http://ectjs.com) format

The following is to cache both a and srv record @[servivce name] into variable and reference the first node oauth2.a[0] IP to generate the nginx config file.
```
<% oauth2 = @['oauth2.service.consul'] %>
location /org/ {
  proxy_pass http://<%- oauth2.a[0] %>:3000/;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Protocol $scheme;
  proxy_set_header X-Forwarded-Host $host;
}
```
The following is to reference the first node mobile.srv[0].name and .port to generate nginx config file
```
<% mobile = @['mobile.service.consul'] %>
location /mobile/ {
  proxy_pass http://<%- mobile.srv[0].name %>:<%- mobile.srv[0].port %>/;
}

```

## Start docker image
```
docker run -v ${PWD}/template:/usr/src/app/template --name config -d twhtanghk/dns-template
```

## Trigger configuration files generation
```
curl -X PUT http://dns-template.service.consul:1337/template/ect
```

* check template/dst folder for the generated config files
