// FA_Gate.v
// Gate-level model of a 1-bit full adder, now with explicit gate delays.
// From this task onward, every gate/assign you write in this lab should
// have an explicit delay -- it's the default way we'll be writing Verilog
// from here on, not a special add-on.
//
// Part (a): add a CONSTANT delay to every gate below, e.g.:
//   xor #(2) (ps, a, b);
// Do this for all five gates, then complete ripple_adder.v (this folder)
// using this full adder, and simulate against tb.v.
//
// Part (b): after completing (a), change every gate's delay from a single
// constant value to a RISE/FALL pair instead, e.g.:
//   xor #(2,3) (ps, a, b);   // rise delay = 2, fall delay = 3
// This tells the simulator to use a different delay depending on whether
// the gate's output is transitioning 0->1 (rise) or 1->0 (fall) -- real
// gates are rarely symmetric this way. Re-simulate with the SAME
// ripple_adder.v and tb.v; nothing else needs to change.

module FA_Gate(
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire ps, pc1, pc2;

  xor #(2,3) (ps,  a,   b);
  and #(2,3) (pc1, a,   b);
  xor #(2,3) (sum, cin, ps);
  and #(2,3) (pc2, cin, ps);
  or #(2,3)  (cout, pc1, pc2);

endmodule


/*
  Task 2 Observations:

  All final settled sums match a+b+cin. Verified for 0+0+0, 7+1+0, 
  15+1+0, 5+3+1, 10+5+0.

  Ripple visible in 7+1 transition (t=20-34): sum passes through 
  0110, 0100, 0000 before settling to 1000. Each carry (c1, c2, c3) 
  settles later than the previous because each FA waits for its 
  cin to settle first.

  Some transitions show cout briefly wrong before settling (e.g. 
  10+5 case: cout=1 during t=86-94, correct cout=0 at t=96). These 
  are glitches from stale carries during propagation, not final 
  errors.
*/

/*
  Task 2 Observations:

  With #(rise, fall) delays instead of constant delay, settling 
  takes longer. Cases 1-4 settle to correct values. Case 5 
  (10+5+0) shows sum=1111 correct but cout=1 at t=100 — the sim 
  ends before cout settles. Rise/fall asymmetry means the ripple 
  window is wider than with constant delays.
*/