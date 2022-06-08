`ifndef XST_SYNTH

`timescale 1ns / 1ps

`include "connect_parameters.v"

import axi4_pkg::*;

module CONNECT_testbench_sample_axi4stream;
  parameter HalfClkPeriod = 5;
  localparam ClkPeriod = 2 * HalfClkPeriod;

  reg CLK;
  reg RST_N;

  axi_stream_interface m0();
  axi_stream_interface m1();
  axi_stream_interface m2();
  axi_stream_interface m3();
  axi_stream_interface s0();
  axi_stream_interface s1();
  axi_stream_interface s2();
  axi_stream_interface s3();

  reg [15 : 0] cycle = 0;
  integer i;

  // Generate Clock
  initial CLK = 0;
  always #(HalfClkPeriod) CLK = ~CLK;

  reg start_m0;
  reg start_m1;
  reg start_m2;
  reg start_m3;

  // Run simulation 
  initial begin
    start_m0 = 0;
    start_m1 = 0;
    start_m2 = 0;
    start_m3 = 0;

    $display("---- Performing Reset ----");
    RST_N = 0; // perform reset (active low) 
    #(5 * ClkPeriod+HalfClkPeriod); 
    RST_N = 1;
    #(HalfClkPeriod);

    #(ClkPeriod);
    start_m0 = 1;
  
    #(ClkPeriod);
    start_m0 = 0;
    start_m1 = 1;

    #(ClkPeriod);
    start_m1 = 0;
    start_m2 = 1;

    #(ClkPeriod);
    start_m2 = 0;
    start_m3 = 1;

    #(ClkPeriod);
    start_m3 = 0;

    #(ClkPeriod * 100);

    test_2();
    test_3();
    test_0();
    test_1();
    $finish;
  end

  axi_dest_t dest_m0 = 2;
  axi_dest_t dest_m1 = 3;
  axi_dest_t dest_m2 = 0;
  axi_dest_t dest_m3 = 1;
  axi_data_t data = 64'hdeadbeef00000000;
  int flag_0 = 1;
  int flag_1 = 1;
  int flag_2 = 1;
  int flag_3 = 1;

  always_ff @(posedge CLK) begin
    cycle <= cycle + 1;
    if (m0.tvalid && m0.tready)
      $display("%d: [m0- t] addr=%x dest=%x", cycle, m0.tdata, m0.tdest);
    if (m1.tvalid && m1.tready)
      $display("%d: [m1- t] addr=%x dest=%x", cycle, m1.tdata, m1.tdest);
    if (s0.tvalid && s0.tready)
      $display("%d: [s0- t] addr=%x dest=%x", cycle, s0.tdata, s0.tdest);
    if (s1.tvalid && s1.tready)
      $display("%d: [s1- t] addr=%x dest=%x", cycle, s1.tdata, s1.tdest);
  end

  task test_0;
    for (int i = 0; i < 24; i++) begin
      if (d0s.buffer[i] != data + i) flag_0 = 0;
      $display("actual:%h expected:%h", d0s.buffer[i], data + i);
    end

    if (flag_0) $display("Pass 0");
    else $display("Fail 0");
  endtask

  task test_1;
    for (int i = 0; i < 24; i++) begin
      if (d1s.buffer[i] != data + i) flag_1 = 0;
      $display("actual:%h expected:%h", d1s.buffer[i], data + i);
    end

    if (flag_1) $display("Pass 1");
    else $display("Fail 1");
  endtask

  task test_2;
    for (int i = 0; i < 24; i++) begin
      if (d2s.buffer[i] != data + i) flag_2 = 0;
      $display("actual:%h expected:%h", d2s.buffer[i], data + i);
    end

    if (flag_2) $display("Pass 2");
    else $display("Fail 2");
  endtask

  task test_3;
    for (int i = 0; i < 24; i++) begin
      if (d3s.buffer[i] != data + i) flag_3 = 0;
      $display("actual:%h expected:%h", d3s.buffer[i], data + i);
    end

    if (flag_3) $display("Pass 3");
    else $display("Fail 3");
  endtask

  NetworkIdealAXI4StreamWrapper dut (
    .CLK,
    .RST_N,
    .m0 (m0),
    .m1 (m1),
    .m2 (m2),
    .m3 (m3),
    .s0 (s0),
    .s1 (s1),
    .s2 (s2),
    .s3 (s3)
  );

  AXI4StreamMasterDevice d0m (
    .CLK,
    .RST_N,
    .axis  (m0),
    .start (start_m0),
    .dest  (dest_m0)
  );

  defparam d0m.ID = 0;

  AXI4StreamMasterDevice d1m (
    .CLK,
    .RST_N,
    .axis  (m1),
    .start (start_m1),
    .dest  (dest_m1)
  );

  defparam d1m.ID = 1;

  AXI4StreamMasterDevice d2m (
    .CLK,
    .RST_N,
    .axis  (m2),
    .start (start_m2),
    .dest  (dest_m2)
  );

  defparam d2m.ID = 1;

  AXI4StreamMasterDevice d3m (
    .CLK,
    .RST_N,
    .axis  (m3),
    .start (start_m3),
    .dest  (dest_m3)
  );

  defparam d3m.ID = 1;

  AXI4StreamSlaveDevice d0s (
    .CLK,
    .RST_N,
    .axis (s0)
  );

  AXI4StreamSlaveDevice d1s (
    .CLK,
    .RST_N,
    .axis (s1)
  );

  AXI4StreamSlaveDevice d2s (
    .CLK,
    .RST_N,
    .axis (s2)
  );

  AXI4StreamSlaveDevice d3s (
    .CLK,
    .RST_N,
    .axis (s3)
  );

  // Dump waveform for gtkwave
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
  end

endmodule

`endif