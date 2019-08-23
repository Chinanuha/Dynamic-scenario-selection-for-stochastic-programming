function [Expsfl_in,Expsfl_out] = SflCalProb(Info,r,prob)
% This function calculate gradient of given decision
  % Inputs
  % - Info: Basic information
  %    o Info.retm: All scenarios
  %    o Info.B: Budget 
  %    o Info.L: Liability 
  % - r: Sample scenarios
  % - x: Decision
  % Outputs
  % - Expsfl_in: Expected shortfall of in-sample
  % - Expsfl_out:  Expected shortfall of out-of-sample

[x,~,~] = SP(Info,r,prob);
Expsfl_in = prob*max(Info.L-Info.B*r*x,0);
Expsfl_out = mean(max(Info.L-Info.B*Info.retm*x,0));