#!/bin/sh

# 检查 UUID 是否设置
if [ -z "$UUID" ]; then
    echo "错误: 未设置 UUID 环境变量！"
    exit 1
fi

# 检查 ARGO_TOKEN 是否设置
if [ -z "$ARGO_TOKEN" ]; then
    echo "错误: 未设置 ARGO_TOKEN 环境变量！"
    exit 1
fi

# 使用 envsubst 动态替换模板中的变量，生成最终的 config.json
envsubst < /etc/sing-box/config.template.json > /etc/sing-box/config.json

# 后台运行 sing-box
sing-box run -c /etc/sing-box/config.json &

# 前台运行 cloudflared 隧道
echo "正在启动 Cloudflare Argo Tunnel..."
cloudflared tunnel --no-autoupdate --protocol http2 run --token ${ARGO_TOKEN}
