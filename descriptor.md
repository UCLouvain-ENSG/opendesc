# NIC Descriptor Structures

## MLX5
### TX Descriptor(s)

* Transmit Data Path:
  + Post send Work Request on the TX Work Queue buffer and ring doorbell.
  + Buffers can be released when CQE is reported.
  + Interrupt and event reporting can be controlled through the CQ and the EQ.
```c
struct mlx5_wqe_ctrl_seg {
	__be32			opmod_idx_opcode;
	__be32			qpn_ds;

	struct_group(trailer,

	u8			signature;
	u8			rsvd[2];
	u8			fm_ce_se;
	union {
		__be32		general_id;
		__be32		imm;
		__be32		umr_mkey;
		__be32		tis_tir_num;
	};

	);
};


struct mlx5_wqe_eth_seg {
	u8              swp_outer_l4_offset;
	u8              swp_outer_l3_offset;
	u8              swp_inner_l4_offset;
	u8              swp_inner_l3_offset;
	u8              cs_flags;
	u8              swp_flags;
	__be16          mss;
	__be32          flow_table_metadata;
	union {
		struct {
			__be16 sz;
			union {
				u8     start[2];
				DECLARE_FLEX_ARRAY(u8, data);
			};
		} inline_hdr;
		struct {
			__be16 type;
			__be16 vlan_tci;
		} insert;
		__be32 trailer;
	};
};


struct mlx5_wqe_data_seg {
	__be32			byte_count;
	__be32			lkey;
	__be64			addr;
};

```


#### RX Descriptor(s)
* Receive Data Path:
  + Post receive Work Request on the RX Work Queue buffer and ring doorbell.
  + Reported CQEs indicate incoming packets including stateless offload indications.
  + Interrupt and event reporting can be controlled through the CQ and the EQ
```c
struct mlx5_cqe64 {
	u8		tls_outer_l3_tunneled;
	u8		rsvd0;
	__be16		wqe_id;
	union {
		struct {
			u8	tcppsh_abort_dupack;
			u8	min_ttl;
			__be16	tcp_win;
			__be32	ack_seq_num;
		} lro;
		struct {
			u8	reserved0:1;
			u8	match:1;
			u8	flush:1;
			u8	reserved3:5;
			u8	header_size;
			__be16	header_entry_index;
			__be32	data_offset;
		} shampo;
	};
	__be32		rss_hash_result;
	u8		rss_hash_type;
	u8		ml_path;
	u8		rsvd20[2];
	__be16		check_sum;
	__be16		slid;
	__be32		flags_rqpn;
	u8		hds_ip_ext;
	u8		l4_l3_hdr_type;
	__be16		vlan_info;
	__be32		srqn; /* [31:24]: lro_num_seg, [23:0]: srqn */
	union {
		__be32 immediate;
		__be32 inval_rkey;
		__be32 pkey;
		__be32 ft_metadata;
	};
	u8		rsvd40[4];
	__be32		byte_cnt;
	__be32		timestamp_h;
	__be32		timestamp_l;
	__be32		sop_drop_qpn;
	__be16		wqe_counter;
	union {
		u8	signature;
		u8	validity_iteration_count;
	};
	u8		op_own;
};

struct mlx5_mini_cqe8 {
	union {
		__be32 rx_hash_result;
		struct {
			__be16 checksum;
			__be16 stridx;
		};
		struct {
			__be16 wqe_counter;
			u8  s_wqe_opcode;
			u8  reserved;
		} s_wqe_info;
	};
	__be32 byte_cnt;
};
```


#### Ring Layout / Flags

* *e.g.* "Descriptors are 16 bytes, ring must be 128‑aligned"
* Describe status and command bit meanings if not obvious.

#### References

* [Datasheet PDF link(s)](https://network.nvidia.com/files/doc-2020/ethernet-adapters-programming-manual.pdf)
* [Linux driver path / commit SHA](https://github.com/torvalds/linux/blob/master/include/linux/mlx5/qp.h)


---

## Template — New NIC

````markdown
### <NIC Family / Chip Name>

#### TX Descriptor (`struct <name>_tx_desc`)
```c
/* Paste the exact structure here */
````


#### RX Descriptor (`struct <name>_rx_desc`)

```c
/* Paste the exact structure here */
```


#### Ring Layout / Flags

* *e.g.* "Descriptors are 16 bytes, ring must be 128‑aligned"
* Describe status and command bit meanings if not obvious.

#### References

* [Datasheet PDF link(s)](https://network.nvidia.com/files/doc-2020/ethernet-adapters-programming-manual.pdf)
* [Linux driver path / commit SHA](https://github.com/torvalds/linux/blob/master/include/linux/mlx5/qp.h)

---
