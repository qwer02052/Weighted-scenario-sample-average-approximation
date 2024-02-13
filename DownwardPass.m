global Alpha PCp PCa CSEv SEv CSEg MING MINL MAXG MAXL Pcap Acap CCOM CLIQ CCG ...
    CCL CSOCG CSOCL CDISG CDISL SGcap SLcap DISGcap DISLcap COMcap LIQcap ...
    SOC0G SOC0L MPC

%% Storage of solution samples according to repetition

det_dicision_list = [];
det_cost_list = [];
Epoch_x_list = {};
Epoch_xfval_list = [];
value_cell = {};
x_list = [];

for k = 1:3
    %% First stage downward pass
    MING = 0.5*(DG(1,k));
    MAXG = 1.5*(DG(1,k));
    MINL = 0.5*(DL(1,k));
    MAXL = 1.5*(DL(1,k));

    fun = @(x) (x(1)*PCp * CSEv / SEv) / (1-exp(-(x(1)/Alpha))) + ...
            (x(2)*PCa * CSEv / SEv) / (1-exp(-(x(2)/Alpha))) + ...
            (x(3)*PCp * CSEg) / (1-exp(-(x(3)/Alpha))) + ... 
            (x(4)*PCa * CSEg) / (1-exp(-(x(4)/Alpha)));
                            
    lb = [100,100,100,100];
    ub = [inf,inf,inf,inf];
    A = [-1 -1 -1 -1
        PCp PCa 0 0 
        1 0 1 0 
        0 1 0 1];
    b = [-(DG(t,k) + DL(t,k) - SOC0G - SOC0L + MING + MINL); SEv/1000; Pcap ; Acap];
    Aeq = [];
    beq = [];
    x0 = [Hmin,Hmin,Hmin,Hmin];
    nonlcon = @Cost_con; 
    options = optimoptions('fmincon','Display','off');
    [x_sol, xfval] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon);
    x_list(k,:) = x_sol;
end   