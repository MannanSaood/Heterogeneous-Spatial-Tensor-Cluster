# Heterogeneous Spatial Tensor Cluster (STC)

## 1. Microarchitecture & Specifications
This parallel-processing spatial cluster is designed to optimize sparse matrix-vector multiplication workloads common in machine learning inference and advanced state-estimation filters (e.g., high-dimensional Kalman filtering).

- **Processing Element (PE) Design**: Arranged in a 4 × 4 weight-stationary array. Each PE features an 8-bit multiplier, a 16-bit accumulator register, and local control logic.
- **Zero-Value Sparsity Gating**: A hardware zero-detection block scans incoming activations. If a byte value is detected as `8'h00`, an Integrated Clock Gate (ICG) cell gates the clock edge to the MAC execution registers for that cycle. This preserves dynamic power and halts accumulator cycles without stalling the pipeline.
- **Double-Buffered Ping-Pong Scratchpads**: Each tile contains two 2KB local SRAM banks. An autonomous DMA data mover pre-fetches the subsequent sub-matrix into Bank B via an AXI4-Stream interface while the core execution engine is actively processing the current matrix segment from Bank A.

## 2. Implementation Milestones
- **Weeks 1–2 (PE Core Clock Gating)**: Implement the PE MAC unit with clock-gating cells. Develop the control logic managing weight-stationary loading sequences.
- **Weeks 3–5 (Ping-Pong Memory Manager)**: Design the local scratchpad controller, coordinating the ping-pong handshake signals across dual-port SRAM boundaries.
- **Weeks 6–8 (System Integration)**: Connect the execution tiles into a 2D grid and wrap the global peripheral interfaces with a standard AMBA AXI4 control bus.

## 3. Advanced Validation Techniques
- **SystemVerilog DPI-C Golden Reference Model**: Write a bit-accurate, high-level behavioral model of the sparse matrix calculation in Python (utilizing NumPy). Instantiate this model using the DPI-C layer (fully compatible with simulators like **Verilator** and Questa).
- **Dynamic Scoreboard Checking**: The Verilator/UVM scoreboard captures the raw tensor stream injected into the design, computes the expected outputs at runtime using the DPI-C model, and asserts bit-for-bit equivalence against the physical RTL output ports.
- **Toggle and FSM Coverage**: Enable toggle coverage on the gated clock trees. Map a functional coverage group confirming that the PEs transitioned through all major cross-states: `Memory Buffer Switch × Sparsity Skip Triggered × Accumulator Overflow Bounds`.

## 4. Current Execution Status
- **Phase 1 & 2 Modules Completed**: `pe_mac.sv` (with ICG), `pe_control.sv`, `pe_tile.sv`, `sram_2kb_dual_port.sv`, `ping_pong_controller.sv`, `axi4_stream_dma.sv`.

### Functional Verification
- **Framework**: Vivado XSim (`xelab`)
- **Coverage**: Basic functional validation via directed testbenches.
- **Status**: `[PASS]` (0 Errors, 0 Warnings) for `tb_ping_pong`.

### Hardware Synthesis (PPA Metrics)
- **Target Architecture**: Xilinx Artix-7 (`xc7a35tcpg236-1`)
- **Tool**: Vivado 2024.2 Synthesis (`synth_design`)

| Metric | Resource | Value | Utilization |
| :--- | :--- | :--- | :--- |
| **Area** | Slice LUTs | 2 | < 0.01% |
| **Area** | Slice Registers | 1 | < 0.01% |
| **Timing** | Fmax | Unconstrained | N/A |
