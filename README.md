# 达梦数据库8容器化部署

## 下载安装包
[官网下载](https://eco.dameng.com/download/)  
操作系统版本选择rhel7或者CentOS7版

## 获取安装文件
1. 解压官网下载的安装包文件`dm8_20251020_x86_win_64.zip`
1. 挂载解压后得到的`dm8_20250506_x86_rh7_64.iso`镜像文件
1. 复制出挂载后的`DMInstall.bin`安装文件

## 构建
1. 将`DMInstall.bin`与`Dockerfile`和`docker-entrypoint.sh`文件放置于同一目录下
1. 进行目录内执行`docker build -t dm8 .`
> 构建阶段可用的`--build-arg`参数列表
> 1. `DM_INSTALL_DIR`达梦数据库程序安装位置，默认值为`/opt/dm8`
> 1. `DM_DATA_DIR`达梦数据库数据存储目录，默认值为`/mnt/data/dm8`

## 运行
```bash
docker run -d --name dm8 -p 5236:5236 \
    -v /mnt/data/dm8:/mnt/data/dm8 \
    -e SYSDBA_PWD=DMdba_123 \
    -e SYSAUDITOR_PWD=DMauditor_123 \
    dm8:latest
``` 
> 可用的环境变量参数列表
> 1. `DEFAULT_DB_NAME`默认数据库名，默认值`DAMENG`
> 1. `INSTANCE_NAME`数据库实例名，默认值`DMSERVER`
> 1. `CASE_SENSITIVE`区分大小写，默认值`Y`
> 1. `SYSDBA_PWD`SYSDBA用户的密码，默认值`DMdba_123`
> 1. `SYSAUDITOR_PWD`SYSAUDITOR用户的密码，默认值`DMauditor_123`
