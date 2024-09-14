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

# 循环执行命令
for ((i=1; i<=$EXECUTION_COUNT; i++))
do
    echo "执行第 $i 次转账"
    yarn cli send -i "$TOKEN_ID" "$RECEIVER_ADDRESS" "$AMOUNT"
    
    # 可选：在每次执行之间添加延迟，以避免可能的速率限制
    sleep 5  # 暂停 5 秒，您可以根据需要调整这个值
done

echo "转账任务完成，共执行 $EXECUTION_COUNT 次"
