class transaction_class;
  rand bit tms;
  bit trst;
  bit cdr1,cir1;
  bit sdr1,sir1;
  bit udr1,uir1;
  bit [3:0] state;

  
  function void display(string name);
    $display("\t tms = %0h", tms);
  endfunction

endclass