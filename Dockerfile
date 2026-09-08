FROM tomcat:10.1-jdk21-temurin

COPY target/01-maven-web-app.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
