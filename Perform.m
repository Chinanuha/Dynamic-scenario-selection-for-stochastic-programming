function [Sf_0ld, Sf_New] = Perform(Info,r_old,p_old,r_new,p_new)


[x_old,~] = SP(Info,r_old,p_old);
Sf_0ld = mean(max(Info.L-Info.B*Info.retm*x_old,0));
[x_new,~] = SP(Info,r_new,p_new);
Sf_New = mean(max(Info.L-Info.B*Info.retm*x_new,0));
