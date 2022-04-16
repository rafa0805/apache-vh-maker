#!/usr/bin/bash

#arg1: domain
#arg2: owner

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

owner=$2
if [[ $owner = '' ]]; then
    echo "EXIT: arg2 (owner user) is required!"
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
vhosts_dir="/etc/httpd/conf.d/vhosts"
if [[ -d ${vhosts_dir} ]]; then
    echo "SKIP: ${vhosts_dir} already exists."
    sudo chmod 755 ${vhosts_dir}
else
    echo "EXEC: create ${vhosts_dir}"
    sudo mkdir -p -m 755 ${vhosts_dir}
fi


if [[ -d ${domain_root} ]]; then
    echo "SKIP: ${domain_root} already exists."
    sudo chmod 755 ${domain_root}
else
    echo "EXEC: create ${domain_root}"
    sudo mkdir -p -m 755 ${domain_root}
fi
sudo chown ${owner}:${owner} ${domain_root}


if [[ -d ${document_root} ]]; then
    echo "SKIP: ${document_root} already exists."
    sudo chmod 755 ${document_root}
else
    echo "EXEC: create ${document_root}"
    sudo mkdir -p -m 755 ${document_root}
fi
sudo chown ${owner}:${owner} ${document_root}


if [[ -d ${logs_dir} ]]; then
    echo "SKIP: ${logs_dir} already exists."
    sudo chmod 777 ${logs_dir}
else
    echo "EXEC: create ${logs_dir}"
    sudo mkdir -p -m 777 ${logs_dir}
fi
sudo chown ${owner}:${owner} ${logs_dir}


### HTTP通信を受け付けるバーチャルホストを設定する
sudo cp template.conf /etc/httpd/conf.d/vhosts/${domain}.conf
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
