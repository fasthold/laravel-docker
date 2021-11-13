# laravel-docker
 
## Build
```
docker build -t my-php-site:latest .
```

## Run
```
docker run -d -p 8001:80 my-php-site:latest
```

## Access
http://ip/index.php

You will get phpinfo page.