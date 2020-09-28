#!/bin/bash
git clone https://github.com/open62541/open62541.git
cd open62541/
mkdir build
cd build/
cmake -DUA_BUILD_EXAMPLES=OFF -DUA_ENABLE_PUBSUB=ON -DUA_ENABLE_PUBSUB_CUSTOM_PUBLISH_HANDLING=ON -DUA_ENABLE_PUBSUB_ETH_UADP=ON -DUA_ENABLE_PUBSUB_ETH_UADP_ETF=ON -DUA_ENABLE_PUBSUB_ETH_UADP_XDP=ON ..
make -j4
gcc -O2 ../examples/pubsub_realtime/pubsub_TSN_publisher.c -I../include -I../plugins/include -Isrc_generated -I../arch/posix -I../arch -I../plugins/networking -I../deps/ -I../src/server -I../src -I../src/pubsub bin/libopen62541.a /usr/local/src/bpf-next/tools/lib/bpf/libbpf.a -lrt -lpthread -lelf -D_GNU_SOURCE -o ./bin/pubsub_TSN_publisher