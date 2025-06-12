#include "qdma_headers.p4"
// define the descriptor parsing for the H2C
// per nic parser

@desc(dir="H2C")
parser qdma_parser(desc_in desc,
                   out desc_t hdr,
                   in  qdma_ctx_t context) {

    state start {
        transition select(context.desc_size) {
            0: parse_desc_8B;
            1: parse_desc_16B;
            2: parse_desc_32B;
            3: parse_desc_64B;
            default: reject;
        }
    }
    state parse_desc_8B {
        desc.extract(hdr.desc8);
        transition accept;
    }

    state parse_desc_16B {
        desc.extract(hdr.desc16);
        transition accept;
    }

    state parse_desc_32B {
        desc.extract(hdr.desc32);
        transition accept;
    }

    state parse_desc_64B {
        desc.extract(hdr.desc64);
        transition accept;
    }
} 
