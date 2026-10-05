`include "interface.sv"
`include "test.sv"
`include "assertion_file.sv"

module new_tb;
  logic tck,tms,trst;
  logic cdr1,sdr1,udr1;
  logic cir1,sir1,uir1;
  logic [3:0] state;
  
  intf vif(tck,trst);

  assign vif.tck  = vif.clk;
  assign vif.trst = vif.reset;

  assign tms   = vif.tms;
  assign state = vif.state;
  assign cdr1  = vif.cdr1;
  assign sdr1  = vif.sdr1;
  assign udr1  = vif.udr1;
  assign cir1  = vif.cir1;
  assign sir1  = vif.sir1;
  assign uir1  = vif.uir1;

  test_case t1(vif);
  tap_controller dut(.tck(vif.tck),
                     .tms(vif.tms),
                     .trst(vif.trst),
                     .cdr1(vif.cdr1),
                     .sdr1(vif.sdr1),
                     .udr1(vif.udr1),
                     .cir1(vif.cir1),
                     .sir1(vif.sir1),
                     .uir1(vif.uir1),
                     .state_out(vif.state)
                    );
  assertion assert_inst(.tck(vif.tck),
  					.tms(vif.tms),
  					.trst(vif.trst),
 					.state_out(vif.state),
  					.cdr1(vif.cdr1),
  					.sdr1(vif.sdr1),
  					.udr1(vif.udr1),
                    .cir1(vif.cir1),
                    .sir1(vif.sir1),
                    .uir1(vif.uir1)
                      );


always #10 tck = ~tck;
initial begin
    $asserton;
    $dumpfile("dump.vcd");
    $dumpvars(0, new_tb);
    tck  = 0;
    trst = 0;
    #5;         
    trst = 1;    
    #1000;
    $finish;
end

endmodule