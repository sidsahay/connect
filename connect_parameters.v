`define NUM_USER_SEND_PORTS 4
`define NUM_USER_RECV_PORTS 4
`define NUM_VCS 2
`define VC_BITS ((`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1)
`define FLIT_DATA_WIDTH 101
`define FLIT_WIDTH (`FLIT_DATA_WIDTH + 5)
`define FLIT_BUFFER_DEPTH 4