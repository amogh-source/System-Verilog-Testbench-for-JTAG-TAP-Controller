class scoreboard;
  
  mailbox mon2scb;

  localparam TEST_LOGIC_RESET = 4'h0; 
  localparam RUN_TEST_IDLE = 4'h1;
  localparam SELECT_DR = 4'h2;
  localparam CAPTURE_DR = 4'h3;
  localparam SHIFT_DR = 4'h4;
  localparam EXIT1_DR = 4'h5; 
  localparam EXIT2_DR = 4'h6;
  localparam UPDATE_DR = 4'h7;
  localparam PAUSE_DR = 4'h8;
  localparam SELECT_IR = 4'h9;
  localparam CAPTURE_IR = 4'hA;
  localparam SHIFT_IR = 4'hB; 
  localparam EXIT1_IR = 4'hC;
  localparam EXIT2_IR = 4'hD;
  localparam UPDATE_IR = 4'hE; 
  localparam PAUSE_IR = 4'hF;
  
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task main;
    transaction_class trans;
    bit pass;
    forever begin
      mon2scb.get(trans);
      
      pass = 1;
      
      case(trans.state)
        CAPTURE_DR: if(!(trans.cdr1 && !trans.sdr1 && !trans.udr1)) pass = 0;
        SHIFT_DR:   if(!(trans.sdr1 && !trans.cdr1 && !trans.udr1)) pass = 0;
        UPDATE_DR:  if(!(trans.udr1 && !trans.cdr1 && !trans.sdr1)) pass = 0;
        CAPTURE_IR: if(!(trans.cir1 && !trans.sir1 && !trans.uir1)) pass = 0;
        SHIFT_IR:   if(!(trans.sir1 && !trans.cir1 && !trans.uir1)) pass = 0;
        UPDATE_IR:  if(!(trans.uir1 && !trans.cir1 && !trans.sir1)) pass = 0;
        default: if(trans.cdr1 || trans.sdr1 || trans.udr1 || trans.cir1 || trans.sir1 || trans.uir1) pass = 0;
      endcase
      
      if(pass)
        $display("[SCOREBOARD PASS] State=%0h, Outputs OK", trans.state);
      else
        $display("[SCOREBOARD FAIL] State=%0h, Unexpected outputs: cdr1=%0b sdr1=%0b udr1=%0b cir1=%0b sir1=%0b uir1=%0b",
                  trans.state, trans.cdr1, trans.sdr1, trans.udr1, trans.cir1, trans.sir1, trans.uir1);
    end
  endtask
endclass