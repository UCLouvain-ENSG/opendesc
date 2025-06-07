# NIC Descriptor Structures

> A living reference for Ethernet Network Interface Controller (NIC) descriptor layouts (TX, RX and ancillary rings).
> **Goal:** make side‑by‑side comparison across vendors/drivers easy.

---

## ✍️ How to use this file

1. **Copy the template** below for every NIC you want to document.
2. Paste the *actual* C structure(s) from the driver or datasheet.
3. Fill in the field‑by‑field table (offsets, sizes, notes).
4. Submit a PR; feel free to add discussion in the *Comments* subsection.

> **Tip:** keep code blocks formatted with <code>\`\`\`c</code> so GitHub renders syntax highlighting.

---

## Template — New NIC

````markdown
### <NIC Family / Chip Name>

#### TX Descriptor (`struct <name>_tx_desc`)
```c
/* Paste the exact structure here */
````

| Offset (bytes) | Field          | Size | Description                   |
| -------------: | -------------- | ---- | ----------------------------- |
|           0x00 | `buffer_addr`  | 64 b | Physical address of TX buffer |
|           0x08 | `cmd_type_len` | 32 b | Cmd field + length            |
|   … add rows … |                |      |                               |

#### RX Descriptor (`struct <name>_rx_desc`)

```c
/* Paste the exact structure here */
```

| Offset (bytes) | Field         | Size | Description                   |
| -------------: | ------------- | ---- | ----------------------------- |
|           0x00 | `buffer_addr` | 64 b | Physical address of RX buffer |
|   … add rows … |               |      |                               |

#### Ring Layout / Flags

* *e.g.* "Descriptors are 16 bytes, ring must be 128‑aligned"
* Describe status and command bit meanings if not obvious.

#### References

* Datasheet PDF link(s)
* Linux driver path / commit SHA

#### Comments

> *Optional notes, quirks, errata, etc.*

````

---

## Example — Intel 82574L (e1000e)

#### TX Descriptor (`struct e1000_tx_desc`)
```c
struct e1000_tx_desc {
    uint64_t buffer_addr; /* Address of the descriptor's data buffer */
    uint16_t length;      /* Data buffer length */
    uint8_t  cso;         /* Checksum offset */
    uint8_t  cmd;         /* Descriptor control */
    uint8_t  status;      /* Descriptor status */
    uint8_t  css;         /* Checksum start */
    uint16_t special;
} __attribute__((packed));
````

| Offset | Field         | Size | Notes                                   |
| -----: | ------------- | ---: | --------------------------------------- |
|   0x00 | `buffer_addr` |  64b | Physical address of frame buffer        |
|   0x08 | `length`      |  16b | Length in bytes                         |
|   0x0A | `cso`         |   8b | Checksum offset into packet             |
|   0x0B | `cmd`         |   8b | `E1000_TXD_CMD_*` bitmask               |
|   0x0C | `status`      |   8b | `E1000_TXD_STAT_*` flags, written by HW |
|   0x0D | `css`         |   8b | Checksum start offset                   |
|   0x0E | `special`     |  16b | VLAN tag or other NIC‑specific data     |

*Ring specifics:* 16‑byte descriptors; ring size program‑mable (power‑of‑2).

---

## 🗂️ Cross‑NIC Comparison Matrix

> *Work‑in‑progress.* Once multiple NICs are filled in, we can add tables that line up common fields (buffer addr, length, status bits) for a quick diff.

---

## License

Distributed under the MIT License. Feel free to clone, modify and submit pull requests.
