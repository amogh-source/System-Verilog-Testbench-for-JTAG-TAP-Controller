`include "environment.sv"

program test_case(intf vif);
  environment env;
  initial begin
    env = new(vif);
    env.gen.repeat_count = 50;
    env.run();
  end
endprogram
