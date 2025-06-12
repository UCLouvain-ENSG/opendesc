#include "ip_headers.p4"

parser ip_parser(packet_in packet,
                out header_t hdr/*,
                inout metadata meta,*/
                ) {
    state start {
        transition parse_ethernet;
    }
    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            ETHERTYPE_IPV4: parse_ipv4;
        }
    }
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol){
            IP_PROTO_UDP: parse_udp;
            IP_PROTO_TCP: parse_tcp;
        }
    }
    state parse_udp {
        packet.extract(hdr.udp);
        transition accept;
    }
    state parse_tcp{
        packet.extract(hdr.tcp);
        transition accept;
    }
}
