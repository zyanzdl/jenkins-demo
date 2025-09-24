# 使用官方 OpenJDK 镜像作为基础镜像
FROM openjdk:11-jre-slim

# 设置工作目录
WORKDIR /app

# 复制 Maven 构建产物
COPY target/demo-app-1.0-SNAPSHOT.jar app.jar

# 容器启动命令
CMD ["java", "-jar", "app.jar"]
