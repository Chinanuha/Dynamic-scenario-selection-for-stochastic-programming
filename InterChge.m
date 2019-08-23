function r_new = InterChge(Info,S,r,p) 
[x,~] = SP(Info,r,p);
Sf = max(Info.L-Info.B*Info.retm*x,0);
for Drop = 1:S
    r_Left = r;
    r_Left(Drop,:)=[];
    r_Add = [Info.retm;r(Drop,:)];
    % [x,~] = SP(Info,r,p);
    % Sf = max(Info.L-Info.B*Info.retm*x,0);
    Q_Real = mean(Sf);
    Q_S =  (Info.L - Info.B*(sum(r_Left*x) + r_Add*x))/S;
    erro = abs(Q_S - Q_Real);
    [~,MinIndex] = min(erro);
    r(Drop,:) = r_Add(MinIndex,:);   
end
r_new = r;
