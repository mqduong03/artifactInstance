#!/bin/bash
echo "=== Creating database config during deployment ==="
cd /var/www/html

# Install PHP PDO for database connectivity
yum install -y php-pdo php-mysqlnd

# Create database configuration
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

echo "=== Database config created on EC2 instance ==="

# Run Magento commands that need database access (these will work from EC2)
echo "=== Running Magento commands from EC2 ==="
php -d memory_limit=3G bin/magento setup:di:compile
php -d memory_limit=4G bin/magento setup:static-content:deploy -f

echo "=== Magento commands completed successfully ==="