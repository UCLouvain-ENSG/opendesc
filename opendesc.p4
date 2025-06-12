#include <core.p4>
#include "ip_headers.p4"

enum OpenDescHashAlgorithm {
    crc32,
    xor16,
    identity
}

extern OpenDescHash {
    bit<32> hash<T>(OpenDescHashAlgorithm algo, bit<32> base, T data);
}

// just like packet_out and packet_in but for tx descriptor and rx completion
extern desc_in {
    void extract<T>(out T data);
    T lookahead<T>();
    void advance(bit<32> bits);
}

extern desc_out {
    void emit<T>(in T data);
}

parser qdma_parser(
    desc_in    desc,
    out desc_t hdr,
    in  qdma_ctx_t context
);

parser ip_parser(
    packet_in  packet,
    out header_t hdr
);

control qdma_rss_compute(
    inout header_t    hdr,
    inout desc_t      desc,
    inout metadata_t  meta
);

control qdma_deparser(
    packet_out packet,
    desc_out   desc_pld,
    in header_t hdr,
    in desc_t   desc
);

package OpenDesc(
    qdma_parser       dp,
    ip_parser         np,
    qdma_rss_compute  compute,
    qdma_deparser     deparser,
    OpenDescHash      hasher
);
