FROM amazonlinux:2
 
# PHPインストール
RUN amazon-linux-extras install -y php7.3
RUN yum install -y php-pecl-zip php-mbstring php-dom
 
# Composerインストール
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
 
# 環境変数設定
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME "/opt/composer"
ENV PATH "$PATH:/opt/composer/vendor/bin"
 
# Laravelインストール
RUN composer global require "laravel/installer"
 
# Laravelプロジェクト作成
WORKDIR /var/www
RUN composer create-project laravel/laravel drew
 
# ポートを公開
EXPOSE 8000
 
WORKDIR /var/www/drew
CMD ["php","artisan","serve","--host","0.0.0.0"]