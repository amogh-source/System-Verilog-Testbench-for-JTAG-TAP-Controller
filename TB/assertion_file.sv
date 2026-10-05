module assertion (
    input logic tck, tms, trst, cdr1, sdr1, udr1, cir1, sir1, uir1,
    input logic [3:0] state_out);

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


// SELECT_DR state
property sdr_to_sir;
  @(posedge tck) (state_out==SELECT_DR && tms==1) |=> (state_out==SELECT_IR);
endproperty
assert_sdr_to_sir: assert property(sdr_to_sir);

property sdr_to_cdr;
  @(posedge tck) (state_out==SELECT_DR && tms==0) |=> (state_out==CAPTURE_DR);
endproperty
assert_sdr_to_cdr: assert property(sdr_to_cdr);

// CAPTURE_DR state
property cdr_to_exit1dr;
  @(posedge tck) (state_out==CAPTURE_DR && tms==1) |=> (state_out==EXIT1_DR);
endproperty
assert_cdr_to_exit1dr: assert property(cdr_to_exit1dr);

property cdr_to_sdr;
  @(posedge tck) (state_out==CAPTURE_DR && tms==0) |=> (state_out==SHIFT_DR);
endproperty
assert_cdr_to_sdr: assert property(cdr_to_sdr);

// SHIFT_DR state
property sdr_to_exit1dr;
  @(posedge tck) (state_out==SHIFT_DR && tms==1) |=> (state_out==EXIT1_DR);
endproperty
assert_sdr_to_exit1dr: assert property(sdr_to_exit1dr);

property sdr_to_sdr;
  @(posedge tck) (state_out==SHIFT_DR && tms==0) |=> (state_out==SHIFT_DR);
endproperty
assert_sdr_to_sdr: assert property(sdr_to_sdr);

// EXIT1_DR state
property exit1dr_to_udr;
  @(posedge tck) (state_out==EXIT1_DR && tms==1) |=> (state_out==UPDATE_DR);
endproperty
assert_exit1dr_to_udr: assert property(exit1dr_to_udr);

property exit1dr_to_pdr;
  @(posedge tck) (state_out==EXIT1_DR && tms==0) |=> (state_out==PAUSE_DR);
endproperty
assert_exit1dr_to_pdr: assert property(exit1dr_to_pdr);

// PAUSE_DR state
property pdr_to_exit2dr;
  @(posedge tck) (state_out==PAUSE_DR && tms==1) |=> (state_out==EXIT2_DR);
endproperty
assert_pdr_to_exit2dr: assert property(pdr_to_exit2dr);

property pdr_to_pdr;
  @(posedge tck) (state_out==PAUSE_DR && tms==0) |=> (state_out==PAUSE_DR);
endproperty
assert_pdr_to_pdr: assert property(pdr_to_pdr);

// EXIT2_DR state
property exit2dr_to_udr;
  @(posedge tck) (state_out==EXIT2_DR && tms==1) |=> (state_out==UPDATE_DR);
endproperty
assert_exit2dr_to_udr: assert property(exit2dr_to_udr);

property exit2dr_to_sdr;
  @(posedge tck) (state_out==EXIT2_DR && tms==0) |=> (state_out==SHIFT_DR);
endproperty
assert_exit2dr_to_sdr: assert property(exit2dr_to_sdr);

// UPDATE_DR state
property udr_to_sdr;
  @(posedge tck) (state_out==UPDATE_DR && tms==1) |=> (state_out==SELECT_DR);
endproperty
assert_udr_to_sdr: assert property(udr_to_sdr);

property udr_to_rt_idle;
  @(posedge tck)(state_out==UPDATE_DR && tms==0)|=>(state_out==RUN_TEST_IDLE);
endproperty
assert_udr_to_rt_idle: assert property(udr_to_rt_idle);


// TEST_LOGIC_RESET state
property tl_rst_to_tl_rst;
  @(posedge tck)(state_out==TEST_LOGIC_RESET && tms==1)|=> (state_out==TEST_LOGIC_RESET);
endproperty
assert_tl_rst_to_tl_rst: assert property(tl_rst_to_tl_rst);

property tl_rst_to_rt_idle;
  @(posedge tck)(state_out==TEST_LOGIC_RESET && tms==0)|=>(state_out==RUN_TEST_IDLE);
endproperty
assert_tl_rst_to_rt_idle: assert property(tl_rst_to_rt_idle);

// RUN_TEST_IDLE test
property rt_idle_to_sdr;
  @(posedge tck) (state_out==RUN_TEST_IDLE && tms==1) |=> (state_out==SELECT_DR);
endproperty
assert_rt_idle_to_sdr: assert property(rt_idle_to_sdr);

  property rt_idle_to_rt_idle;
    @(posedge tck) (state_out==RUN_TEST_IDLE && tms==0) |=> (state_out==RUN_TEST_IDLE);
  endproperty
  assert_rt_idle_to_rt_idle: assert property(rt_idle_to_rt_idle);

  // SELECT_IR state
  property sir_to_tl_rst;
    @(posedge tck) (state_out==SELECT_IR && tms==1) |=> (state_out==TEST_LOGIC_RESET);
  endproperty
  assert_sir_to_tl_rst: assert property(sir_to_tl_rst);  

  property sir_to_cir;
    @(posedge tck) (state_out==SELECT_IR && tms==0) |=> (state_out==CAPTURE_IR);
  endproperty
  assert_sir_to_cir: assert property(sir_to_cir);

  // CAPTURE_IR state
  property cir_to_exit1ir;
    @(posedge tck) (state_out==CAPTURE_IR && tms==1) |=> (state_out==EXIT1_IR);
  endproperty
  assert_cir_to_exit1ir: assert property(cir_to_exit1ir);

  property cir_to_sir;
    @(posedge tck) (state_out==CAPTURE_IR && tms==0) |=> (state_out==SHIFT_IR);
  endproperty
  assert_cir_to_sir: assert property(cir_to_sir);

  // SHIFT_IR state
  property sir_to_exit1ir;
    @(posedge tck) (state_out==SHIFT_IR && tms==1) |=> (state_out==EXIT1_IR);
  endproperty
  assert_sir_to_exit1ir: assert property(sir_to_exit1ir);

  property sir_to_sir;
    @(posedge tck) (state_out==SHIFT_IR && tms==0) |=> (state_out==SHIFT_IR);
  endproperty
  assert_sir_to_sir: assert property(sir_to_sir);

  // EXIT1_IR state
  property exit1ir_to_uir;
    @(posedge tck) (state_out==EXIT1_IR && tms==1) |=> (state_out==UPDATE_IR);
  endproperty
  assert_exit1ir_to_uir: assert property(exit1ir_to_uir);

  property exit1ir_to_pir;
    @(posedge tck) (state_out==EXIT1_IR && tms==0) |=> (state_out==PAUSE_IR);
  endproperty
  assert_exit1ir_to_pir: assert property(exit1ir_to_pir);

  // PAUSE_IR state
  property pir_to_exit2ir;
    @(posedge tck) (state_out==PAUSE_IR && tms==1) |=> (state_out==EXIT2_IR);
  endproperty
  assert_pir_to_exit2ir: assert property(pir_to_exit2ir);

  property pir_to_pir;
    @(posedge tck) (state_out==PAUSE_IR && tms==0) |=> (state_out==PAUSE_IR);
  endproperty
  assert_pir_to_pir: assert property(pir_to_pir);

  // EXIT2_IR state
  property exit2ir_to_uir;
    @(posedge tck) (state_out==EXIT2_IR && tms==1) |=> (state_out==UPDATE_IR);
  endproperty
  assert_exit2ir_to_uir: assert property(exit2ir_to_uir);

  property exit2ir_to_sir;
    @(posedge tck) (state_out==EXIT2_IR && tms==0) |=> (state_out==SHIFT_IR);
  endproperty
  assert_exit2ir_to_sir: assert property(exit2ir_to_sir);

  // UPDATE_IR state
  property uir_to_sdr;
    @(posedge tck) (state_out==UPDATE_IR && tms==1) |=> (state_out==SELECT_DR);
  endproperty
  assert_uir_to_sdr: assert property(uir_to_sdr);

  property uir_to_rt_idle;
    @(posedge tck) (state_out==UPDATE_IR && tms==0) |=> (state_out==RUN_TEST_IDLE);
  endproperty
  assert_uir_to_rt_idle: assert property(uir_to_rt_idle);

  property check_trst;
    @(posedge tck) ($fell(trst)) |=> (state_out==TEST_LOGIC_RESET);
  endproperty
  assert_check_trst: assert property(check_trst);


  // Data Registers
  property check_cdr1;
    @(posedge tck) cdr1 |-> (state_out==CAPTURE_DR);
  endproperty
  assert_check_cdr1: assert property(check_cdr1);

  property check_sdr1;
    @(posedge tck) sdr1 |-> (state_out==SHIFT_DR);
  endproperty
  assert_check_sdr1: assert property(check_sdr1);

  property check_udr1;
    @(posedge tck) udr1 |-> (state_out==UPDATE_DR);
  endproperty
  assert_check_udr1: assert property(check_udr1);

  // Instruction Registers
  property check_cir1;
    @(posedge tck) cir1 |-> (state_out==CAPTURE_IR);
  endproperty
  assert_check_cir1: assert property(check_cir1);

  property check_sir1;
    @(posedge tck) sir1 |-> (state_out==SHIFT_IR);
  endproperty
  assert_check_sir1: assert property(check_sir1);

  property check_uir1;
    @(posedge tck) uir1 |-> (state_out==UPDATE_IR);
  endproperty
  assert_check_uir1: assert property(check_uir1);

//Valid states - to prevent unknown state
  property valid_state_true;
    @(posedge tck)
      state_out inside {
        TEST_LOGIC_RESET, RUN_TEST_IDLE, SELECT_DR, CAPTURE_DR, SHIFT_DR,
        EXIT1_DR, PAUSE_DR, EXIT2_DR, UPDATE_DR,
        SELECT_IR, CAPTURE_IR, SHIFT_IR, EXIT1_IR, PAUSE_IR, EXIT2_IR, UPDATE_IR
      };
  endproperty
  assert_valid_state_true: assert property(valid_state_true);

// No overlap between instruction and data register
  property output_signal_2xcondition1;
    @(posedge tck) !((cdr1 && sdr1) || (cdr1 && udr1) || (sdr1 && udr1));
  endproperty
  assert_output_signal_2xcondition1: assert property(output_signal_2xcondition1);

  property output_signal_2xcondition2;
    @(posedge tck) !((cir1 && sir1) || (cir1 && uir1) || (sir1 && uir1));
  endproperty
  assert_output_signal_2xcondition2: assert property(output_signal_2xcondition2);

endmodule
