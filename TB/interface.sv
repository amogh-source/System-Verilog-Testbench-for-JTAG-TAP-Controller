interface intf(input logic clk, reset);
  
  logic tck;
  logic tms;
  logic trst;
  logic cdr1,sdr1,udr1;
  logic cir1,sir1,uir1;
  logic [3:0] state;

endinterface