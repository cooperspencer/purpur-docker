FROM adoptopenjdk/openjdk16:latest AS build

ARG purpur_ci_url=https://api.pl3x.net/v2/purpur/1.17.1/latest/download
ENV PURPUR_CI_URL=$purpur_ci_url

WORKDIR /opt/minecraft

# Download purpur_unpatched
ADD ${PURPUR_CI_URL} purpur_unpatched.jar

# Run purpur_unpatched and obtain patched jar
RUN /opt/java/openjdk/bin/java -jar /opt/minecraft/purpur_unpatched.jar; exit 0

# Copy built jar
RUN mv /opt/minecraft/cache/patched*.jar purpur.jar

FROM adoptopenjdk/openjdk16:latest AS runtime

# Working directory
WORKDIR /data

# Obtain runable jar from build stage
COPY --from=build /opt/minecraft/purpur.jar /opt/minecraft/purpur.jar

# Volumes for the external data (Server, World, Config...)
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set memory size
ARG memory_size=3G
ENV MEMORYSIZE=$memory_size

# Set Java Flags
ARG java_flags="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV JAVAFLAGS=$java_flags

WORKDIR /data

# Entrypoint with java optimisations
ENTRYPOINT /opt/java/openjdk/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /opt/minecraft/purpur.jar --nojline nogui