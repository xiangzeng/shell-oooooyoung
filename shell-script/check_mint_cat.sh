#!/bin/bash

# 检查是否提供了阈值参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <threshold>"
    exit 1
fi

# 设置阈值
threshold=$1

# 配置文件路径
config_file=~/cat-token-box/packages/cli/config.json

# 修改 config.json 文件中的 maxFeeRate
update_config() {
    jq --argjson maxFeeRate "$threshold" '.maxFeeRate = $maxFeeRate' "$config_file" > tmp.$$.json && mv tmp.$$.json "$config_file"
}

# 获取费用信息并判断是否符合条件
check_fee() {
    response=$(curl -s https://explorer.unisat.io/fractal-mainnet/api/bitcoin-info/fee)
    fastestFee=$(echo $response | jq '.data.fastestFee')
    if [ $fastestFee -le $threshold ]; then
        return 0
    else
        echo "fastestFee ($fastestFee) 超过阈值 ($threshold)，等待中..."
        return 1
    fi
}

command="sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5"

while true; do
    if check_fee; then
        update_config
        for i in {1..3}; do
            $command

            if [ $? -ne 0 ]; then
                echo "命令执行失败，退出循环"
                exit 1
            fi
        done
    fi

    sleep 5
done
