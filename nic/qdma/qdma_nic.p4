#include "../../arch/opendesc.p4"
#include "qdma_header.p4"

@H2C
parser DescParser(desc_in desc,
                  in  qdma_h2c_ctx_t ctx,
                  out h2c_desc_t  dh) {
    state start {
        dh.size = ctx.desc_size;
        transition select(ctx.desc_size) {
            0: parse8;
            1: parse16;
            2: parse32;
            3: parse64;
        }
    }
    state parse8  { desc.extract(dh.d8);  transition accept; }
    state parse16 { desc.extract(dh.d16); transition accept; }
    state parse32 { desc.extract(dh.d32); transition accept; }
    state parse64 { desc.extract(dh.d64); transition accept; }
}

parser PktParser(packet_in pkt_in, out hdr_t ph) {
    state start {
        pkt_in.extract(ph.ethernet);
        transition select(ph.ethernet.etherType) {
            0x0800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        pkt_in.extract(ph.ipv4);
        transition select(ph.ipv4.protocol) {
            6  : parse_tcp;
            17 : parse_udp;
            default: accept;
        }
    }
    state parse_tcp { pkt_in.extract(ph.tcp); transition accept; }
    state parse_udp { pkt_in.extract(ph.udp); transition accept; }
}

control MainControl(inout hdr_t   ph,
                    inout h2c_desc_t  dh,
                    inout meta_t  m) {
    apply {
        m.desc_size = dh.size;
        if (ph.ipv4.isValid() && ph.tcp.isValid()) {
            hash(m.rss_hash, HashAlgorithm.crc32, 0,
                 { ph.ipv4.srcAddr, ph.ipv4.dstAddr,
                   ph.tcp.srcPort,  ph.tcp.dstPort });
        } else {
            m.rss_hash = 0;
        }
    }
}

control PktDeparser(packet_out pkt_out,
                    in hdr_t   ph,
                    in meta_t  m) {
    apply {
        if (ph.ethernet.isValid()) { pkt_out.emit(ph.ethernet); }
        if (ph.ipv4.isValid())     { pkt_out.emit(ph.ipv4); }
        if (ph.tcp.isValid())      { pkt_out.emit(ph.tcp); }
        if (ph.udp.isValid())      { pkt_out.emit(ph.udp); }
    }
}

@C2H
control CmptDeparser(cmpt_out cmpt_out,
                     qdma_c2h_ctx_t ctx,
                     in hdr_t   ph,
                     in h2c_desc_t  dh,
                     in meta_t  m) {
    apply {
        switch(ctx.cmpt_size) {
            0: {
                cmpt_8B_t c;  c.user_data = m.rss_hash[61:0];
                c.color = 1; c.err = 0;  cmpt_out.emit(c);
            }
            1: {
                cmpt_16B_t c; c.user_data = (bit<126>)m.rss_hash;
                c.color = 1; c.err = 0;  cmpt_out.emit(c);
            }
            2: {
                cmpt_32B_t c; c.user_data = (bit<254>)m.rss_hash;
                c.color = 1; c.err = 0;  cmpt_out.emit(c);
            }
            3: {
                cmpt_64B_t c; c.user_data = (bit<510>)m.rss_hash;
                c.color = 1; c.err = 0;  cmpt_out.emit(c);
            }
        }
    }
}

OpenDescNIC<
        qdma_h2c_ctx_t,
        qdma_c2h_ctx_t,
        h2c_desc_t,
        hdr_t,
        meta_t>(
    DescParser(),
    PktParser(),
    MainControl(),
    PktDeparser(),
    CmptDeparser()) main;

