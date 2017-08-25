#!/bin/bash

# Получить полный путь к файлу
echo $(readlink -f $1)