# ベースイメージを指定
# 今回は LTS の 8.9.4 にする
# alpine は 軽量の linux OS
FROM node:8.9.4-alpine

# node.js の環境変数を定義する
# 本番環境では production
ENV NODE_ENV=development

# 雛形を生成するのに必要なパッケージのインストール
RUN apk add --update alpine-sdk

#ethereum-jsでpythonが必要
RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base

RUN git config --global url."https://".insteadOf git://

RUN yarn cache clean
RUN yarn install

RUN npm update npm

# RUN sudo yarn global add ganache-cli

# RUN sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}
RUN sudo npm install -g --unsafe-perm ganache-cli
RUN mkdir -p /var/ganache
 
ENV DOCKER true
ENV DATADIR /var/ganache
# データを永続化する場合、次回以降も同じmnemonicとnetworkIdで立ち上げる必要性があります
# https://github.com/trufflesuite/ganache-cli/issues/407
ENV MNEMONIC pillows andymori al tomoyuki spitz abc quruli whoops fukurouz air bluehearts highlows
ENV NETWORKID 5777
 
ENTRYPOINT ["sh", "-c", "ganache-cli --host=0.0.0.0 --db=${DATADIR} --mnemonic=\"${MNEMONIC}\" --networkId=${NETWORKID}"]

# ポート8545番を開放する
EXPOSE 8545

# ワーキングディレクトリ作成
WORKDIR /src
