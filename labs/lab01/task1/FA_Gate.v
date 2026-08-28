// FA_Gate.v
// Gate-level model of a 1-bit full adder. No delays yet -- that starts in
// Task 2. This task is purely about gate ordering.
//
// Part (a): leave this file exactly as it is, compile, and simulate.
// Part (b): AFTER completing part (a), come back and reorder the five gate
//           instantiations below into any different sequence, then
//           re-simulate with the same tb.v and compare.

module FA_Gate(
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire ps, pc1, pc2;

  xor  (ps,  a,   b);
  and  (pc1, a,   b);
  xor  (sum, cin, ps);
  and  (pc2, cin, ps);
  or   (cout, pc1, pc2);

endmodule

/*
  Task 1 Observations:

  (a) sum and cout match the full-adder truth 
      table at all 8 input combinations. Outputs update instantly.

  (b) no waveform change. 
      Verilog gate primitives model concurrent hardware, not 
      sequential statements.the simulator builds the same dataflow graph regardless 
      of the order gates appear in the file.

  (c) outputs now settle after propagation delay rather than instantly. During the settling 
      window, transient wrong values appear on sum and cout — 
      e.g. at t=22 cout is briefly 1 before correcting to 0 at t=24 
      for input (a=1, b=0, cin=0).

      Reason: gates sit at different depths in the circuit. ps and pc1 
      are depth 1, sum and pc2 are depth 2 (they need ps), and cout 
      is depth 3 (needs pc1 and pc2). When inputs change, depth-1 
      gates settle at t+2, depth-2 at t+4, depth-3 at t+6. During 
      propagation, downstream gates compute using stale upstream 
      values, producing brief hazards. Once all gates finish 
      propagating, outputs are correct.
*