#!/usr/bin/bash

#arg1: domain
#arg2: email

### 環境チェック
# 標準出力：条件により
# ファイル出力：なし
if ! type certbot > /dev/null 2>&1; then
    echo "please install certbot. terminating..."
    exit
fi

### コマンドからの入力
# 標準出力：条件により
# ファイル出力：なし
email=$2
if [[ $email = '' ]]; then
    echo "EXIT: arg2 (email of sys adm) is required!"
    exit
fi

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
vhosts_dir="/etc/httpd/conf.d/vhosts"
if [[ ! -d ${vhosts_dir} ]]; then
    exit
fi
if [[ ! -d ${domain_root} ]]; then
    exit
fi
if [[ ! -d ${document_root} ]]; then
    exit
fi
if [[ ! -d ${logs_dir} ]]; then
    exit
fi

ssl_includes_dir="/etc/httpd/conf.d/vhosts/includes/ssl"
if [[ -d ${ssl_includes_dir} ]]; then
    echo "SKIP: ${ssl_includes_dir} already exists."
    sudo chmod 755 ${ssl_includes_dir}
else
    echo "EXEC: create ${ssl_includes_dir}"
    sudo mkdir -p -m 755 ${ssl_includes_dir}
fi

### Let's Encyptの証明書を取得
sudo certbot certonly --webroot -w ${document_root} -d ${domain} --email ${email} --agree-tos --non-interactive
certification_path="/etc/letsencrypt/live/${domain}/cert.pem"
privkey_path="/etc/letsencrypt/live/${domain}/privkey.pem"
chain_path="/etc/letsencrypt/live/${domain}/chain.pem"


# # ### 証明書の存在を確認
# if [[ -e ${certification_path} ]]; then
#     echo "file ${certification_path} successfully created."
# else
#     echo "EXIT: file ${certification_path} is missing..."
#     exit
# fi

# if [[ -e ${privkey_path} ]]; then
#     echo "file ${privkey_path} successfully created."
# else
#     echo "EXIT: file ${privkey_path} is missing..."
#     exit
# fi

# if [[ -e ${chain_path} ]]; then
#     echo "file ${chain_path} successfully created."
# else
#     echo "EXIT: file ${chain_path} is missing..."
#     exit
# fi


### SSL証明書の読み込み
sudo cp ssl_includes_template.conf /etc/httpd/conf.d/vhosts/includes/ssl/${domain}.conf
sudo sed -i -e "s@{{ __domain__ }}@${domain}@g" /etc/httpd/conf.d/vhosts/includes/ssl/${domain}.conf
