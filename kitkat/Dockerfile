FROM kylemanna/aosp AS build

WORKDIR /java
COPY jdk-6u45-linux-x64.bin /java
RUN ./jdk-6u45-linux-x64.bin && rm /java/jdk-6u45-linux-x64.bin

FROM kylemanna/aosp

# we need make 3.x
RUN echo "deb http://cz.archive.ubuntu.com/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --allow-downgrades -y make=3.81-8.2ubuntu3 && \
     apt-get clean autoclean && apt-get autoremove --yes && \
     rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=build /java /java
ENV ANDROID_JAVA_HOME=/java/jdk1.6.0_45
ENV JAVA_HOME=/java/jdk1.6.0_45
ENV PATH=/java/jdk1.6.0_45/bin:$PATH
RUN echo "export PATH=\$JAVA_HOME/bin:\$PATH" > /etc/profile.d/java_path.sh
RUN echo "PATH=\"/java/jdk1.6.0_45/bin:\$PATH\"" >> /etc/skel/.profile
RUN echo "PATH=\"/java/jdk1.6.0_45/bin:\$PATH\"" >> /root/.profile
RUN sed -i 's/exec sudo -E -u aosp \$args/exec sudo -E -u aosp env \"PATH=$PATH\" \$args/g' /root/docker_entrypoint.sh

# Build the file:
#  - copy jdk-6u45-linux-x64.bin to the current directory
#  - docker build . -t androidkitkat_build

# Start building (see https://github.com/kylemanna/docker-aosp):
#  - docker run --mount source=kitkat_build,destination=/aosp -ti --rm androidkitkat_build
#  - curl -O https://raw.githubusercontent.com/kylemanna/docker-aosp/master/tests/build-kitkat.sh
#  - chmod +x build-kitkat.sh
#  - ./build-kitkat.sh docker