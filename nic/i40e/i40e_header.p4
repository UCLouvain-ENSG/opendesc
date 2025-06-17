#include <core.p4>
/*
share the following in a global file between all nics
*/
typedef bit<48> mac_t;
typedef bit<32> ip4_t;
typedef bit<16> port_t;

aheader eth_t { mac_t dst; mac_t src; bit<16> et; }
header ip4_t {
    bit<4> v; bit<4> hl; bit<8> ds; bit<16> len;
    bit<16> id; bit<3> flg; bit<13> off; bit<8> ttl; bit<8> p;
    bit<16> sum; ip4_t src; ip4_t dst;
}
header tcp_t { port_t sport; port_t dport; bit<32> seq; bit<32> ack;
               bit<4> off; bit<3> res; bit<3> ecn; bit<6> flg;
               bit<16> win; bit<16> csum; bit<16> urg; }
header udp_t { port_t sport; port_t dport; bit<16> len; bit<16> csum; }

struct pkt_hdr_t { eth_t eth; ip4_t ip4; tcp_t tcp; udp_t udp; }

//---------NIC typess

header i40e_tx_desc_t { 
    bit<64> buf_addr; 
    bit<64> cmd_type_off_bsz; 
}


struct i40e_rx_wb_16B_t {
    bit<16> mirr_fcoe;         /* mirroring_status | fcoe_ctx_id   */
    bit<16> l2tag1;
    bit<32> rss_fd_fcoe;       /* rss | fd_id | fcoe_param         */
    bit<64> status_error_len;  /* pkttype | status | err | length  */
}

struct i40e_rx_wb_32B_t {
    /* qword0 */
    bit<16> mirr_fcoe;  
    bit<16> l2tag1;  
    bit<32> rss_fd_fcoe;
    /* qword1 */
    bit<64> status_error_len;
    /* qword2 */
    bit<16> ext_status; 
    bit<16> rsvd; 
    bit<16> l2tag2_1; 
    bit<16> l2tag2_2;
    /* qword3 */
    bit<32> flex_bytes_lo_pe; 
    bit<32> flex_bytes_hi_fd;
}

struct desc_t {
    i40e_tx_desc_t desc;
}

struct meta_t{
    bit<32> rss;
}

struct i40e_c2h_ctx_t{
    bit<1> cmpt_size;
}

struct i40e_h2c_ctx_t{
}
