FROM java:8
WORKDIR /
ADD target/*.war HelloWorld.war
EXPOSE 8080
CMD java -jar HelloWorld.war
