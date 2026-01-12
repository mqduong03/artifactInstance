#!/bin/bash
cd /var/www/html

yum install -y php-pdo php-mysqlnd

mkdir -p app/etc
cat << 'EOL' > app/etc/env.php
<?php
return [
    'db' => [
        'connection' => [
            'default' => [
                'host' => 'artifactinstance-db.c2tme8q64742.us-east-1.rds.amazonaws.com',
                'dbname' => 'mysql',
                'username' => 'admin',
                'password' => 'MySecurePassword123'
            ]
        ]
    ]
];
EOL

php -d memory_limit=3G bin/magento setup:di:compile
php -d memory_limit=4G bin/magento setup:static-content:deploy -f