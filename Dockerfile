FROM debian
MAINTAINER christopher.hoskin@gmail.com

RUN apt-get update && apt-get install -y default-jre-headless
RUN apt-get install -y unzip wget
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/connector-server-zip/1.4.3.0/connector-server-zip-1.4.3.0.zip
RUN unzip connector-server-zip-1.4.3.0.zip -d /opt/
RUN rm connector-server-zip-1.4.3.0.zip

RUN mkdir /etc/connector-server
RUN mkdir -p /opt/connid-connector-server/bundles
RUN mkdir -p /opt/connid-connector-server/bundles-lib

RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.cmd/0.2/net.tirasa.connid.bundles.cmd-0.2.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.cmd-0.2.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.ad/1.3.0/net.tirasa.connid.bundles.ad-1.3.0.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.ad-1.3.0.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.rest/1.0.1/net.tirasa.connid.bundles.rest-1.0.1.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.rest-1.0.1.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.csvdir/0.8.5/net.tirasa.connid.bundles.csvdir-0.8.5.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.csvdir-0.8.5.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.ldap/1.5.1/net.tirasa.connid.bundles.ldap-1.5.1.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.ldap-1.5.1.jar
RUN wget http://repo1.maven.org/maven2/net/tirasa/connid/bundles/net.tirasa.connid.bundles.googleapps/1.4.0/net.tirasa.connid.bundles.googleapps-1.4.0.jar -O /opt/connid-connector-server/bundles/net.tirasa.connid.bundles.googleapps-1.4.0.jar

RUN wget http://nexus.evolveum.com/nexus/service/local/repositories/releases/content/com/evolveum/polygon/connector-databasetable/1.4.2.0/connector-databasetable-1.4.2.0.jar -O /opt/connid-connector-server/bundles/connector-databasetable-1.4.2.0.jar
RUN wget http://nexus.evolveum.com/nexus/content/groups/public/com/evolveum/polygon/connector-csv/2.1/connector-csv-2.1.jar -O /opt/connid-connector-server/bundles/connector-csv-2.1.jar
RUN wget http://nexus.evolveum.com/nexus/content/repositories/releases/com/evolveum/polygon/connector-ldap/1.5/connector-ldap-1.5.jar -O /opt/connid-connector-server/bundles/connector-ldap-1.5.jar
RUN wget http://nexus.evolveum.com/nexus/content/repositories/releases/com/evolveum/polygon/connector-ldap/1.4.5/connector-ldap-1.4.5.jar -O /opt/connid-connector-server/bundles/connector-ldap-1.4.5.jar
RUN wget http://nexus.evolveum.com/nexus/service/local/repositories/openicf-releases/content/org/forgerock/openicf/connectors/oracle-connector/1.1.0.0/oracle-connector-1.1.0.0.jar -O /opt/connid-connector-server/oracle-connector-1.1.0.0.jar
RUN wget http://nexus.evolveum.com/nexus/content/repositories/openicf-releases/org/forgerock/openicf/connectors/scriptedsql-connector/1.1.2.0.em3/scriptedsql-connector-1.1.2.0.em3.jar -O /opt/connid-connector-server/bundles/scriptedsql-connector-1.1.2.0.em3.jar



COPY connector-server.properties /etc/connector-server/connector-server.properties

RUN java -cp "/opt/connid-connector-server/lib/framework/*" org.identityconnectors.framework.server.Main -setKey -key fibble -properties /etc/connector-server/connector-server.properties

RUN mkdir -p /opt/connid-connector-server/test-files/

COPY test-file1.csv /opt/connid-connector-server/test-files/test-file1.csv
COPY test-file2.csv /opt/connid-connector-server/test-files/test-file2.csv

EXPOSE 8759
CMD [ "java", "-cp", "/opt/connid-connector-server/lib/framework/*", "org.identityconnectors.framework.server.Main", "-run", "-properties", "/etc/connector-server/connector-server.properties" ]
