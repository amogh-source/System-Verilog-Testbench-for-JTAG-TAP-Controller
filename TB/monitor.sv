class monitor;
  
  virtual intf vif;
  mailbox mon2scb;
        
  covergroup cg_inst @(posedge vif.tck);
    state_transition: coverpoint vif.state{
        bins TEST_LOGIC_RESET = {0};
        bins RUN_TEST_IDLE = {1};
        bins SELECT_DR = {2};
        bins CAPTURE_DR = {3};
        bins SHIFT_DR = {4};
        bins EXIT1_DR = {5};
        bins EXIT2_DR = {6};
        bins UPDATE_DR = {7};
        bins PAUSE_DR = {8};
        bins SELECT_IR = {9};
        bins CAPTURE_IR = {10};
        bins SHIFT_IR = {11};
        bins EXIT1_IR = {12};
        bins EXIT2_IR = {13};
        bins UPDATE_IR = {14};
        bins PAUSE_IR = {15};   
    }
    tms_flip: coverpoint vif.tms{
        bins zero = {0};
        bins one = {1};
    }
    trst_reset: coverpoint vif.trst{
        bins zero = {0};
        bins one = {1};    
    }
    capture_data_register: coverpoint vif.cdr1{
        bins zero = {0};
        bins one = {1};
    }
    shift_data_register: coverpoint vif.sdr1{
        bins zero = {0};
        bins one = {1};
    }
    update_data_register: coverpoint vif.udr1{
        bins zero = {0};
        bins one = {1};
    }
    capture_instruction_register: coverpoint vif.cir1{
        bins zero = {0};
        bins one = {1};
    }
    shift_instruction_register: coverpoint vif.sir1{
        bins zero = {0};
        bins one = {1};
    }
    update_instruction_register: coverpoint vif.uir1{
        bins zero = {0};
        bins one = {1};
    }  
endgroup
  
  function new(virtual intf vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
    this.cg_inst = new();
  endfunction
      

  task main;
    transaction_class trans;
    
    forever begin
      @(posedge vif.clk);
      trans = new();
      trans.tms   = vif.tms;
      trans.trst  = vif.trst;
      trans.cdr1  = vif.cdr1;
      trans.cir1  = vif.cir1;
      trans.sdr1  = vif.sdr1;
      trans.sir1  = vif.sir1;
      trans.udr1  = vif.udr1;
      trans.uir1  = vif.uir1;
      trans.state = vif.state;
      mon2scb.put(trans);
      $display("[MONITOR] Captured: state=%0h, cdr1=%0b, sdr1=%0b, udr1=%0b, cir1=%0b, sir1=%0b, uir1=%0b",
                trans.state, trans.cdr1, trans.sdr1, trans.udr1, trans.cir1, trans.sir1, trans.uir1);
      $display ("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
      
    end
  endtask
  
endclass