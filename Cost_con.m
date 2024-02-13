function [c,ceq] = Cost_con(x)
global Alpha PCp PCa CSEv SEv CSEg CCG CCL CSOCG CSOCL CDISG CDISL MPC
c(1) = (x(1)*PCp * CSEv / SEv) / (1-exp(-(x(1)/Alpha))) + ...
        (x(2)*PCa * CSEv / SEv) / (1-exp(-(x(2)/Alpha))) + ...
        (x(3)*PCp * CSEg) / (1-exp(-(x(3)/Alpha))) + ... 
        (x(4)*PCa * CSEg) / (1-exp(-(x(4)/Alpha))) + ...
            - MPC;
ceq = [];
end 