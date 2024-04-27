# Run:
#     $ docker build -t local/chirp .
# this is how to build passing the new version from the web:
#  https://trac.chirp.danplanet.com/chirp_next 
# docker build --build-arg chirpversion=XXXXXX -t local/chirp .
#     $ docker run -ti --rm --device=/dev/ttyUSB0:/dev/ttyUSB0 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix linuxluser/chirp
# 
FROM ubuntu:latest

#ARG chirpversion=20231223
ARG chirpversion=20240427

RUN apt-get update && \
    apt-get install -y software-properties-common wget python3 python3-pip python3-pip-whl python3-wxgtk4.0 unzip

RUN /usr/bin/wget --no-check-certificate https://trac.chirp.danplanet.com/chirp_next/next-${chirpversion}/chirp-${chirpversion}-py3-none-any.whl
#RUN /usr/bin/pip3 install /chirp-$chirpversion-py3-none-any.whl
RUN /usr/bin/pip3 install --break-system-packages /chirp-$chirpversion-py3-none-any.whl
#install ijv V3
RUN /usr/bin/wget --no-check-certificate -O firmware_IJV_V3.zip "https://www.domox.org/?file=firmware_IJV_V3.zip" && unzip firmware_IJV_V3.zip
RUN mv *.py /usr/local/lib/python3.12/dist-packages/chirp/drivers/
#install ijv V2
RUN /usr/bin/wget --no-check-certificate -O firmware_IJV.zip "https://www.domox.org/?file=firmware_IJV.zip" && unzip -o firmware_IJV.zip
#RUN ls head -n -5 uvk5_IJV_v2.9R5_jh11i1.py > uvk5_IJV_v2.py && mv uvk5_IJV_v2.py /usr/local/lib/python3.12/dist-packages/chirp/drivers/
RUN head -n -5 uvk5_IJV_v2.9R5*.py > uvk5_IJV_v2.py && mv uvk5_IJV_v2.py /usr/local/lib/python3.12/dist-packages/chirp/drivers/


CMD ["/usr/local/bin/chirp"]
