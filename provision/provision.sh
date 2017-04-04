#!/bin/sh

echo -------------------------------------------------
echo
echo                    基本設定
echo
echo -------------------------------------------------

echo -------------------------------
echo
echo historyフォーマット設定
echo
echo -------------------------------

HISTTIMEFORMAT='%y/%m/%d %H:%M:%S ';

echo -------------------------------
echo
echo タイムゾーン設定
echo
echo -------------------------------

echo cp /usr/share/zoneinfo/Japan /etc/localtime

echo -------------------------------
echo
echo remiレポジトリ取得
echo
echo -------------------------------

curl -OL http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

echo -------------------------------------------------
echo
echo                    Apache設定
echo
echo -------------------------------------------------

echo -------------------------------
echo
echo Apacheインストール
echo
echo -------------------------------

yum -y localinstall remi-release-6.rpm
yum -y install httpd httpd-devel

echo -------------------------------
echo
echo Apache自動起動設定
echo
echo -------------------------------

chkconfig httpd on

echo -------------------------------
echo
echo Apache関連設定ファイル書き換え
echo
echo -------------------------------

mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
cp /var/www/html/provision/httpd/httpd.conf /etc/httpd/conf/httpd.conf

echo -------------------------------------------------
echo
echo                    MySQL設定
echo
echo -------------------------------------------------

echo -------------------------------
echo
echo MySQLインストール
echo
echo -------------------------------

curl -OL http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
yum -y localinstall mysql-community-release-el6-5.noarch.rpm
yum -y install mysql mysql-devel mysql-server
mv /usr/my.conf /usr/my.conf.bk
cp /var/www/html/provision/mysql/my.conf /usr/my.conf

echo -------------------------------
echo
echo MySQLDB作成、初期パスワード設定
echo
echo -------------------------------

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO root@\"%\" IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql -uroot -e "FLUSH PRIVILEGES;"
mysql -uroot -e "create database testdb;"

echo -------------------------------------------------
echo
echo                    PHP設定
echo
echo -------------------------------------------------

echo -------------------------------
echo
echo PHPインストール
echo
echo -------------------------------

yum -y install --enablerepo=remi,remi-php56 php php-mysql php-xml php-pear php-pdo php-cli php-mbstring php-gd php-mcrypt php-common php-devel php-bcmath
mv /etc/php.ini /etc/php.ini.bk
cp /var/www/html/provision/php/php.ini /etc/php.ini

echo -------------------------------
echo
echo xdebugインストール
echo
echo -------------------------------

wget http://www.xdebug.org/files/xdebug-2.3.3.tgz
tar xzvf xdebug-2.3.3.tgz
cd xdebug-2.3.3/
phpize
./configure --enable-xdebug
make
make install

echo -------------------------------------------------
echo
echo                    ビルド用ツール設定
echo
echo -------------------------------------------------

echo -------------------------------
echo
echo Gitインストール composer用
echo
echo -------------------------------

yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum -y install perl-ExtUtils-MakeMaker
cd /usr/local/src/
wget https://www.kernel.org/pub/software/scm/git/git-2.9.3.tar.gz
tar xzvf git-2.9.3.tar.gz
cd git-2.9.3
make prefix=/usr/local all
make prefix=/usr/local install
echo ----- git version
echo | git --version
echo -----

echo -------------------------------
echo
echo composerインストール
echo
echo -------------------------------

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
echo ----- composer version
echo | /usr/local/bin/composer --version
echo -----

echo -------------------------------
echo
echo nodejs,npmインストール
echo
echo -------------------------------

yum -y install nodejs npm
echo ----- node version
echo | node --version
echo -----
echo ----- npm version
echo | npm --version
echo -----
