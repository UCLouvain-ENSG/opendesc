
#include <core.p4>

typedef bit<48> macAddr_t;
typedef bit<32> ipv4Addr_t;
typedef bit<16> port_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header ipv4_t {
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

header tcp_t {
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

header udp_t {
    port_t srcPort;
    port_t dstPort;
    bit<16> len;
    bit<16> checksum;
}

struct hdr_t {
    ethernet_t ethernet;
    ipv4_t     ipv4;
    tcp_t      tcp;
    udp_t      udp;
}

/* Pipeline related metadata */
struct meta_t {
    bit<32> rss_hash;
}

header qdma_h2c_desc_8B_t{ 
    bit<64> src_addr; 
}
header qdma_h2c_desc_16B_t { 
    bit<48> mdata; 
    bit<16> len; 
    bit<64> src_addr; 
}
header qdma_h2c_desc_32B_t {
    bit<32> mdata; 
    bit<16> len; 
    bit<64> src_addr;
    bit<32> reserved; 
    bit<64> user_data;
}
header qdma_h2c_desc_64B_t {
    bit<32> mdata; 
    bit<16> len; 
    bit<64> src_addr;
    bit<64> user_data; 
    bit<64> user_data2;
    bit<64> reserved; 
    bit<64> timestamp;
}

header cmpt_8B_t  { 
    bit<62> user_data; 
    bit<1> color; 
    bit<1> err; 
}

header cmpt_16B_t { 
    bit<126> user_data; 
    bit<1> color; 
    bit<1> err; 
}

header cmpt_32B_t { 
    bit<254> user_data; 
    bit<1> color; 
    bit<1> err; 
}
header cmpt_64B_t { 
    bit<510> user_data; 
    bit<1> color; 
    bit<1> err; 
}

struct qdma_h2c_ctx_t {
    bit<2>  desc_size;   // 0=8B,1=16B,2=32B,3=64B
    bit<3>  vf_id;
    bit<1>  pf_id;
    bit<6>  queue_id;
    /*other context info*/
}

// per-queue ctx once the queue is determimed
// used by the deparser as a hint to understand
// the cmpt layout
struct qdma_c2h_ctx{
    bit<2> cmpt_size;
    // TODO add other fields
}

struct h2c_desc_t {
    qdma_h2c_desc_8B_t  d8;
    qdma_h2c_desc_16B_t d16;
    qdma_h2c_desc_32B_t d32;
    qdma_h2c_desc_64B_t d64;
}

struct c2h_cmpt_t {
    cmpt_8B_t  c8;
    cmpt_16B_t c16;
    cmpt_32B_t c32;
    cmpt_64B_t c64;
}

