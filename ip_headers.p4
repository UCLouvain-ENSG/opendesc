#ifndef _IP_HEADERS_P4_
#define _IP_HEADERS_P4_

typedef bit<48> macAddr_t;
typedef bit<32> ipv4Addr_t;
typedef bit<16> port_t;

header ethernet_h {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header ipv4_h {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ipv4Addr_t srcAddr;
    ipv4Addr_t dstAddr;
}

header tcp_h {
    port_t srcPort;
    port_t dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  flags;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

// UDP header
header udp_h {
    port_t srcPort;
    port_t dstPort;
    bit<16> len;
    bit<16> checksum;
}

struct header_t {
    ethernet_t ethernet;
    ipv4_t     ipv4;
    tcp_t      tcp;
    udp_t      udp;
}

// Metadata structure
struct metadata_t {
    bit<32> rss_hash;
}

#endif
