FROM debian
MAINTAINER christopher.hoskin@gmail.com

RUN apt-get update && apt-get install -y default-jre-headless
RUN apt-get install -y unzip wget
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/connector-server-zip/1.4.2.0/connector-server-zip-1.4.2.0.zip
RUN unzip connector-server-zip-1.4.2.0.zip -d /opt/
RUN rm connector-server-zip-1.4.2.0.zip

RUN mkdir /etc/connector-server
RUN mkdir -p /opt/connid-connector-server/bundles
RUN mkdir -p /opt/connid-connector-server/bundles-lib

RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.cmd/0.2/net.tirasa.connid.bundles.cmd-0.2.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.cmd-0.2.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.ad/1.3.0/net.tirasa.connid.bundles.ad-1.3.0.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.ad-1.3.0.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.rest/1.0.1/net.tirasa.connid.bundles.rest-1.0.1.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.rest-1.0.1.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.csvdir/0.8.5/net.tirasa.connid.bundles.csvdir-0.8.5.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.csvdir-0.8.5.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.ldap/1.5.1/net.tirasa.connid.bundles.ldap-1.5.1.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.ldap-1.5.1.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.googleapps/1.4.0/net.tirasa.connid.bundles.googleapps-1.4.0.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.googleapps-1.4.0.jar


COPY connector-server.properties /etc/connector-server/connector-server.properties

RUN java -cp "/opt/connid-connector-server/lib/framework/*" org.identityconnectors.framework.server.Main -setKey -key fibble -properties /etc/connector-server/connector-server.properties

EXPOSE 8759
CMD [ "java", "-cp", "/opt/connid-connector-server/lib/framework/*", "org.identityconnectors.framework.server.Main", "-run", "-properties", "/etc/connector-server/connector-server.properties" ]
