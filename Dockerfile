##### 基础镜像环境
FROM centos:7 AS base

ARG DM_INSTALL_DIR=/opt/dm8
ARG DM_DATA_DIR=/mnt/data/dm8

ENV DM_INSTALL_DIR=$DM_INSTALL_DIR
ENV DM_DATA_DIR=$DM_DATA_DIR

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN groupadd -g 12001 dinstall && useradd -g dinstall -m -u 12001 -d /home/dmdba -s /bin/bash dmdba && \
    mkdir -p ${DM_INSTALL_DIR} ${DM_DATA_DIR} && \
    chown -R dmdba:dinstall ${DM_INSTALL_DIR} ${DM_DATA_DIR}


##### 安装阶段
FROM base AS install

COPY DMInstall.bin /home/dmdba/install/

USER dmdba

RUN grep -v '^#' <<CONFIG | sh /home/dmdba/install/DMInstall.bin -i
# 安装语言，1中文，2英文
1
# 是否输入Key路径
n
# 是否设置时区
y
# 中国时区
21
# 1典型安装，2服务器安装，3客户端，4自定义
2
# 安装路径
${DM_INSTALL_DIR}
# 确认安装路径
y
# 确认安装
y
CONFIG


##### 输出阶段
FROM base

COPY --from=install $DM_INSTALL_DIR $DM_INSTALL_DIR
COPY --from=install $DM_DATA_DIR $DM_DATA_DIR
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

USER dmdba

EXPOSE 5236

WORKDIR /home/dmdba

ENTRYPOINT ["/docker-entrypoint.sh"]
