FROM balenalib/raspberrypi4-64-debian:buster-build as build
COPY . sx1302_hal
RUN cd sx1302_hal && make

# The run time container that will go to devices
FROM balenalib/raspberrypi4-64-debian:buster-run

# Grab our node modules for the build step
COPY --from=build ./sx1302_hal /sx1302_hal
WORKDIR /sx1302_hal/packet_forwarder
RUN ln -s ../tools/reset_lgw.sh reset_lgw.sh
RUN ln -s global_conf.json.sx1250.EU868 global_conf.json
RUN perl -pi.bak -e 's/localhost/miner/g' global_conf.json

CMD ["./lora_pkt_fwd"]
