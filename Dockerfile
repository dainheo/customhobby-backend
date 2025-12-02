# Java 17 이미지 사용
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Gradle 파일 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# Windows 환경 대비: gradlew 줄바꿈 변환
RUN apt-get update && apt-get install -y dos2unix && dos2unix gradlew

# 실행 권한 부여
RUN chmod +x gradlew

# 빌드
RUN ./gradlew bootJar -x test

# 실행 단계
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${PORT}"]
