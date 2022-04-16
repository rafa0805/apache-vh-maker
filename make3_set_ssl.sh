#!/usr/bin/bash

#arg1: domain

### 環境チェック
# 標準出力：条件により
# ファイル出力：なし
if ! type httpd > /dev/null 2>&1; then
    echo "please install httpd. terminating..."
    exit
fi


### コマンドからの入力
# 標準出力：条件により
# ファイル出力：なし

domain=$1
if [[ $domain = '' ]]; then
    echo "EXIT: arg1 (SERVER_NAME) is required!"
    exit
fi


### 主なパラメータを作成
# 標準出力：なし
# ファイル出力：なし
base_path="/var/www"
domain_root="${base_path}/${domain}"
document_root="${domain_root}/html"
logs_dir="${domain_root}/logs"


### 必要なディレクトリを作成&権限調整
# 標準出力：あり
# ファイル出力：あり
### 必要なディレクトリを作成&権限調整
# 標準出力：あり
# ファイル出力：あり
vhosts_dir="/etc/httpd/conf.d/vhosts"
if [[ ! -d ${vhosts_dir} ]]; then
    exit
fiexample_user
if [[ ! -d ${domain_root} ]]; then
    exit
fi
if [[ ! -d ${document_root} ]]; then
    exit
fi
if [[ ! -d ${logs_dir} ]]; then
    exit
fi


### HTTP通信を受け付けるバーチャルホストを設定する
sudo cp ssl_template.conf /etc/httpd/conf.d/vhosts/${domain}.conf
sudo sed -i -e "s@{{ __domain__ }}@${domain}@g" /etc/httpd/conf.d/vhosts/${domain}.conf
sudo sed -i -e "s@{{ __document_root__ }}@${document_root}@g" /etc/httpd/conf.d/vhosts/${domain}.conf


### 権限ファイルを作成する
if [[ ! -f "/etc/httpd/conf/common_require.conf" ]]; then
    echo "common_require.conf will be created."
    sudo cp common_require.conf /etc/httpd/conf/common_require.conf
fi

# ### Apache起動
status=`sudo apachectl configtest`
echo ${status}
# if [[ ${status} != "Syntax OK" ]]; then
#     exit
# fi
echo "EXEC: sudo apachectl graceful"
#sudo apachectl graceful
