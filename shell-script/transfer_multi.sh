#!/bin/bash

# 提示用户输入变量
read -p "请输入 Token ID: " TOKEN_ID
read -p "请输入收款地址: " RECEIVER_ADDRESS
read -p "请输入转账数量: " AMOUNT
read -p "请输入执行次数: " EXECUTION_COUNT

# 确认输入的信息
echo "您输入的信息如下："
echo "Token ID: $TOKEN_ID"
echo "收款地址: $RECEIVER_ADDRESS"
echo "转账数量: $AMOUNT"
echo "执行次数: $EXECUTION_COUNT"
read -p "信息是否正确？(y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "已取消操作"
    exit 1
fi

# 初始化计数器
SUCCESS_COUNT=0
FAIL_COUNT=0

# 循环执行命令
for ((i=1; i<=$EXECUTION_COUNT; i++))
do
    echo "执行第 $i 次转账"
    if yarn cli send -i "$TOKEN_ID" "$RECEIVER_ADDRESS" "$AMOUNT"; then
        echo "转账成功"
        ((SUCCESS_COUNT++))
    else
        echo "转账失败"
        ((FAIL_COUNT++))
    fi
    
    echo "等待 30 秒..."
    sleep 30
done

echo "转账任务完成，共执行 $EXECUTION_COUNT 次"
echo "成功次数: $SUCCESS_COUNT"
echo "失败次数: $FAIL_COUNT"
