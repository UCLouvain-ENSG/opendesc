#include "qdma_parser.p4"
#include "ip_parser.p4"

control qdma_rss_compute(
    inout header_t hdr,
    inout desc_t desc,
    inout metadata_t meta
) {
    action compute_rss(){
        bit<32> hash_input;

        if (hdr.tcp.isValid()) {
            hash_input = OpenDescHash.hash<bit<128>>(
                OpenDescHashAlgorithm.crc32,
                32w0,
                {
                    hdr.ipv4.srcAddr,
                    hdr.ipv4.dstAddr,
                    //hdr.ipv4.protocol,
                    hdr.tcp.srcPort,
                    hdr.tcp.dstPort
                }
            );
        } else if (hdr.udp.isValid()) {
            hash_input = OpenDescHash.hash<bit<128>>(
                OpenDescHashAlgorithm.crc32,
                32w0,
                {
                    hdr.ipv4.srcAddr,
                    hdr.ipv4.dstAddr,
                    //hdr.ipv4.protocol,
                    hdr.udp.srcPort,
                    hdr.udp.dstPort
                }
            );
        } /*else {
            hash_input = hash(
                OpenDescHashAlgorithm.crc32,
                32w0,
                {
                    hdr.ipv4.srcAddr,
                    hdr.ipv4.dstAddr,
                    hdr.ipv4.protocol
                }
            );
        }*/

        meta.rss_hash = hash_input;
    }
     apply {
        if (hdr.ipv4.isValid()) {
            compute_rss();
        }
    }
} 

control qdma_deparser (packet_out packet, desc_out desc_pld,
                    in header_t hdr, in desc_t desc) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.udp);
        packet.emit(hdr.tcp);
    }
    /*
    similarly deparse the completion notification to be communicated to the driver
    */
}
// defined in open-desc model
OpenDesc(
    qdma_parser(),
    ip_parser(),
    qdma_rss_compute(),
    qdma_deparser()
);

