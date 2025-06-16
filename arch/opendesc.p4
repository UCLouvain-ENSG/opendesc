
#ifndef __OPENDESC_P4__
#define __OPENDESC_P4__
#include <core.p4>

// PNA DEF
enum PNA_HashAlgorithm_t {
  IDENTITY,
  CRC32,
  CRC32_CUSTOM,
  CRC16,
  CRC16_CUSTOM,
  ONES_COMPLEMENT16,  /// One's complement 16-bit sum used for IPv4 headers,
  TARGET_DEFAULT      /// target implementation defined
}
//PNA DEF
extern Hash<O> {
  Hash(PNA_HashAlgorithm_t algo);
  O get_hash<D>(in D data);
  O get_hash<T, D>(in T base, in D data, in T max);
}
//PNA DEF
extern Checksum<W> {
  Checksum(PNA_HashAlgorithm_t hash);
  void clear();
  void update<T>(in T data);
  W    get();
}


extern desc_in {
    void extract<T>(out T hdr);
}

extern cmpt_out {
    void emit<T>(in T hdr);
}

parser DescParser<typename H2C_CTX_T, typename DESC_T>(                // user-supplied definition
        desc_in       desc_in,        // PCIe byte-stream
        in  H2C_CTX_T h2c_ctx,        // e.g. per queue context that helps to determine the layout of desc_in
        out DESC_T    desc_hdr);     // per nic layout definition

parser PktParser<typename PKT_T>(                
        packet_in     packet_in,
        out PKT_T     pkt_hdr); // per pipeline def.

//TODO may consider addig fixed metadata for the pipeline def. 
control MainControl<typename PKT_T, typename DESC_T, typename META_T>(
        inout PKT_T   pkt_hdr,
        inout DESC_T  desc_hdr,
        inout META_T  pipe_meta); // metadata that travels along the pipeline

//is desc_t needed here?
control PktDeparser<typename PKT_T, typename META_T>(
        packet_out    packet_out,
        in PKT_T      pkt_hdr,
        in META_T     pipe_meta);

control CmptDeparser<typename PKT_T, typename C2H_CTX_T, typename DESC_T, typename META_T>(
        cmpt_out      cmpt_out,       // PCIe completion stream
        in PKT_T      pkt_hdr,
        in DESC_T     desc_hdr,
        in META_T     pipe_meta);

package OpenDescNIC<
          typename H2C_CTX_T,
          typename C2H_CTX_T,
          typename DESC_T,
          typename PKT_T,
          typename META_T>
        (
        DescParser   dp,
        PktParser    pp,
        MainControl  mc,
        PktDeparser  pd,
        CmptDeparser cd
        );

#endif
