#!/bin/bash
# set -x #отладка
# Задание 1
echo "Шо мы тут имеем"
dpkg -l #выводим установленные пакеты
echo "Ага..."
dpkg -s nginx # ищем nginx

if sudo dpkg -l | grep ii | grep nginx
then
        ver=$(nginx -v 2>&1)
        sudo apt purge nginx -y
        echo "$ver удалено"
else
        echo "Нема нічого (nginx)"
fi
