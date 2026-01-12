#!/bin/bash
cd /var/www/html

yum install -y php-pdo php-mysqlnd mysql

# Create MySQL user that allows connections from any host
mysql -h artifactinstance-db.c2tme8q64742.us-east-1.rds.amazonaws.com -u admin -pMySecurePassword123 -e "CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'AppPassword123'; GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%'; FLUSH PRIVILEGES;"

mkdir -p app/etc
cat << 'EOL' > app/etc/env.php
<?php
return [
    'db' => [
        'connection' => [
            'default' => [
                'host' => 'artifactinstance-db.c2tme8q64742.us-east-1.rds.amazonaws.com',
                'dbname' => 'mysql',
                'username' => 'appuser',
                'password' => 'AppPassword123'
            ]
        ]
    ]
];
EOL

php -d memory_limit=3G bin/magento setup:di:compile
php -d memory_limit=4G bin/magento setup:static-content:deploy -f