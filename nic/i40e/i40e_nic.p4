parser DescParser(desc_in desc,
                  in  i40e_h2_ctx_t ctx,
                  out rx_desc_t dh) {
    state start{
      desc.extract(dh.desc);
      transition accept;
    }
}


// same control goes here as QDMA
// same pkt deparser goes here as QDMA

control CmptDeparser(cmpt_out cmpt,
                     in hdr_t ph,
                     in desc_t dh,
                     in meta_t m) {
    apply {
        if (m.cmpt_size == 1) {
            i40e_rx_wb_32B_t d;
            d.mirr_fcoe        = 0;
            d.l2tag1           = 0;
            d.rss_fd_fcoe      = m.rss;
            d.status_error_len = 0x1;
            d.ext_status       = 0;
            d.rsvd             = 0;
            d.l2tag2_1         = 0;
            d.l2tag2_2         = 0;
            d.flex_bytes_lo_pe = 0;
            d.flex_bytes_hi_fd = 0;
            cmpt.emit(d);
        } else {
            i40e_rx_wb_16B_t d;
            d.mirr_fcoe        = 0;
            d.l2tag1           = 0;
            d.rss_fd_fcoe      = m.rss;
            d.status_error_len = 0x1;
            cmpt.emit(d);
        }
    }
}

OpenDescNIC<
        i40e_h2c_ctx_t,
        i40e_c2h_ctx_t,
        h2c_desc_t,
        hdr_t,
        meta_t>(
    DescParser(),
    PktParser(),
    MainControl(),
    PktDeparser(),
    CmptDeparser()) main;


