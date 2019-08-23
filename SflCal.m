function [Expsfl_in,Expsfl_out] = SflCal(Info,r,x)
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
  
insample = r; % sample data
Expsfl_in = mean(max(Info.L-Info.B*insample*x,0));
Expsfl_out = mean(max(Info.L-Info.B*Info.retm*x,0));