class driver;
  mailbox gen2driv;
  virtual intf vif;
  int no_transactions;
  
  function new(virtual intf vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction
  
  task reset;
    wait(!vif.trst);
    $display("Reset started.");
    vif.tms <= 0;
    wait(vif.trst);
    $display("Reset Ended.");
  endtask
  
  task main;
    forever begin
      transaction_class trans;
      gen2driv.get(trans);
      $display("---------------------------------------------------------");
      $display("TRANSACTION NO = %d",no_transactions+1);
      vif.tms <= trans.tms;
      trans.display("OUTPUT");
      @(posedge vif.clk);
       no_transactions++;
    end
  endtask
endclass