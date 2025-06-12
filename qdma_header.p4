//h2c HOST to CARD
//C2H CARD to HOST
header qdma_h2c_desc_8B_h {
    bit<64> src_addr;
}

header qdma_h2c_desc_16B_h {
    bit<32> metadata;
    bit<16> len;
    bit<64> src_addr;
}

header qdma_h2c_desc_32B_h {
    bit<32> metadata;
    bit<16> len;
    bit<64> src_addr;
    bit<32> reserved;
    bit<64> user_data;
}

header qdma_h2c_desc_64B_h {
    bit<32> metadata;
    bit<16> len;
    bit<64> src_addr;
    bit<64> user_data;
    bit<64> user_data2;
    bit<64> reserved;
    bit<64> timestamp;
}

// per-NIC specific context
struct qdma_ctx_t {
    bit<2>  desc_size;   // 0:8B, 1:16B, 2:32B, 3:64B
    bit<3>  vf_id;
    bit<1>  pf_id;
    bit<6>  queue_id;
}

header cmpt_8B_t {
    bit<62> user_data;
    bit<1>  color;
    bit<1>  err;
}

// 16-Byte Completion Descriptor (128 bits)
header cmpt_16B_t {
    bit<126> user_data;
    bit<1>   color;
    bit<1>   err;
}

// 32-Byte Completion Descriptor (256 bits)
header cmpt_32B_t {
    bit<254> user_data;
    bit<1>   color;
    bit<1>   err;
}

// 64-Byte Completion Descriptor (512 bits)
header cmpt_64B_t {
    bit<510> user_data;
    bit<1>   color;
    bit<1>   err;
}


//possible descriptors
struct desc_t {
    qdma_h2c_desc_8B_h  desc8;
    qdma_h2c_desc_16B_h desc16;
    qdma_h2c_desc_32B_h desc32;
    qdma_h2c_desc_64B_h desc64;
}

// could use any of these at runtime!
struct desc_t {
    qdma_c2h_cmpt_8B_t  desc8;
    qdma_c2h_cmpt_16B_t desc16;
    qdma_c2h_cmpt_32B_t desc32;
    qdma_c2h_cmpt_64B_t desc64;
}

struct qdma_context_t {
    qdma_ctx_t qdma_ctx;
}
