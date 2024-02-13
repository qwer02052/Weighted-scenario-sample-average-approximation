% Example considering only hydrogen demand uncertainty

%% Generation of the second stage hydrogen phase transformation decision sample

COM_list_sce = {};
LIQ_list_sce = {};

for k = 1 : S
    COM_list = [];
    LIQ_list = [];
    while numel(COM_list) ~= sample_num
        ag = 0;
        bg = COMcap;
        al = 0;
        bl = LIQcap;
    
        COM_sample = ag + (bg - ag) * rand(1);
        LIQ_sample = al + (bl - al) * rand(1);
    
        if COM_sample + LIQ_sample <= sum(x_list(k,:))
    
            COM_list = [COM_list, COM_sample];
            LIQ_list = [LIQ_list, LIQ_sample];
        end
    end

    COM_list_sce{k} = COM_list;
    LIQ_list_sce{k} = LIQ_list;
end


%% Generation of second stage hydrogen charging decision sample

CG_list_sce = {};
CL_list_sce = {};

for k = 1 : S
    CG_list = [];
    CL_list = [];
    for p = 1 : sample_num    
        ag = 0;
        bg = min(CGcap,COM_list_sce{k}(p));
        al = 0;
        bl = min(LIQcap,LIQ_list_sce{k}(p));
    
        CG_sample = ag + (bg - ag) * rand(1);
        CL_sample = al + (bl - al) * rand(1); 
    
        CG_list(p) = CG_sample;
        CL_list(p) = CL_sample;    
    end

    CG_list_sce{k} = CG_list;
    CL_list_sce{k} = CL_list;
end

%% Derive representative samples from each scenario
Rep_COM =[];
Rep_LIQ =[];
Rep_CG =[];
Rep_CL =[];

for k = 1 : S

    master_cost_list = [];

    for p = 1 : sample_num
        sample_vector = [COM_list_sce{k}(p),LIQ_list_sce{k}(p),CG_list_sce{k}(p),CL_list_sce{k}(p)];

        cost = (x_list(k,1)*PCp * CSEv / SEv) / (1-exp(-(x_list(k,1)/Alpha))) + ...
                (x_list(k,2)*PCa * CSEv / SEv) / (1-exp(-(x_list(k,2)/Alpha))) + ...
                (x_list(k,3)*PCp * CSEg) / (1-exp(-(x_list(k,3)/Alpha))) + ... 
                (x_list(k,4)*PCa * CSEg) / (1-exp(-(x_list(k,4)/Alpha))) + ...
                sample_vector(1)*CCOM*1000 + sample_vector(2)*CLIQ *1000+ sample_vector(3)*CCG*1000 + sample_vector(4)*CCL*1000;

        master_cost_list = [master_cost_list;sample_vector,cost];
    end
    
    [M, I] = min(master_cost_list(:, end));

    Rep_COM(k) = master_cost_list(I,1);
    Rep_LIQ(k) = master_cost_list(I,2);
    Rep_CG(k) = master_cost_list(I,3);
    Rep_CL(k) = master_cost_list(I,4);

end

%% Scenario sample integration process

Intergrated_COM = sum(De_ksi_prob(t,:) .* Rep_COM);
Intergrated_LIQ = sum(De_ksi_prob(t,:) .* Rep_LIQ);
Intergrated_CG = sum(De_ksi_prob(t,:) .* Rep_CG);
Intergrated_CL = sum(De_ksi_prob(t,:) .* Rep_CL);
        
%% Generation of the first stage hydrogen production decision sample

HPR_list_sce = {};
HAR_list_sce = {};
HPE_list_sce = {};
HAE_list_sce = {};

for k = 1 : S
    HPR_list = [];
    HAR_list = [];
    HPE_list = [];
    HAE_list = [];

    while numel(HPR_list) ~= sample_num

        apr = Hmin;
        bpr = Pcap + Acap;

        aar = Hmin;
        bar = Pcap + Acap;

        ape = Hmin;
        bpe = Pcap + Acap;

        aae = Hmin;
        bae = Pcap + Acap;
 
        HPR_sample = Hmin + (Pcap + Acap - Hmin) * rand(1);
        HAR_sample = Hmin + (Pcap + Acap - Hmin) * rand(1);
        HPE_sample = Hmin + (Pcap + Acap - Hmin) * rand(1);
        HAE_sample = Hmin + (Pcap + Acap - Hmin) * rand(1);
    
        if (HPR_sample + HAR_sample + HPE_sample + HAE_sample >= Intergrated_COM + Intergrated_LIQ) && ...
                (HPR_sample + HPE_sample <= Pcap) && (HAR_sample + HAE_sample <= Acap) && ...
                (PCp*HPR_sample + PCa*HAR_sample <= SEv) && ...
                (HPR_sample + HAR_sample + HPE_sample + HAE_sample >= DG(t,k) + DL(t,k) + MING + MINL - (SOC0G + SOC0L))
    
            HPR_list = [HPR_list, HPR_sample];
            HAR_list = [HAR_list, HAR_sample];
            HPE_list = [HPE_list, HPE_sample];
            HAE_list = [HAE_list, HAE_sample];
        end
    end

    HPR_list_sce{k} = HPR_list;
    HAR_list_sce{k} = HAR_list;
    HPE_list_sce{k} = HPE_list;
    HAE_list_sce{k} = HAE_list;
end

%% Generation of the first stage hydrogen production intersection decision sample

HPR_list_sce_int = {};
HAR_list_sce_int = {};
HPE_list_sce_int = {};
HAE_list_sce_int = {};


HPR_list_int = [];
HAR_list_int = [];
HPE_list_int = [];
HAE_list_int = [];

while numel(HPR_list_int) ~= sample_num

    apr = Hmin;
    bpr = Pcap + Acap;

    aar = Hmin;
    bar = Pcap + Acap;

    ape = Hmin;
    bpe = Pcap + Acap;

    aae = Hmin;
    bae = Pcap + Acap;

    HPR_sample_int = Hmin + (Pcap + Acap - Hmin) * rand(1);
    HAR_sample_int = Hmin + (Pcap + Acap - Hmin) * rand(1);
    HPE_sample_int = Hmin + (Pcap + Acap - Hmin) * rand(1);
    HAE_sample_int = Hmin + (Pcap + Acap - Hmin) * rand(1);

    if (HPR_sample_int + HAR_sample_int + HPE_sample_int + HAE_sample_int >= Intergrated_COM + Intergrated_LIQ) && ...
            (HPR_sample_int + HPE_sample_int <= Pcap) && (HAR_sample_int + HAE_sample_int <= Acap) && ...
            (PCp*HPR_sample_int + PCa*HAR_sample_int <= SEv) && ...
            (HPR_sample_int + HAR_sample_int + HPE_sample_int + HAE_sample_int >= min(DG(t,:)) + min(DL(t,:)) + MING + MINL - (SOC0G + SOC0L))

        HPR_list_int = [HPR_list_int, HPR_sample_int];
        HAR_list_int = [HAR_list_int, HAR_sample_int];
        HPE_list_int = [HPE_list_int, HPE_sample_int];
        HAE_list_int = [HAE_list_int, HAE_sample_int];
    end
end

%% Derive representative samples from each scenario

% In each scenario

Rep_HPR =[];
Rep_HAR =[];
Rep_HPE =[];
Rep_HAE =[];

for k = 1 : S

    master_cost_list = [];

    for p = 1 : sample_num
        sample_vector = [HPR_list_sce{k}(p),HAR_list_sce{k}(p),HPE_list_sce{k}(p),HAE_list_sce{k}(p)];

        cost = (sample_vector(1)*PCp * CSEv / SEv) / (1-exp(-(sample_vector(1)/Alpha))) + ...
                (sample_vector(2)*PCa * CSEv / SEv) / (1-exp(-(sample_vector(2)/Alpha))) + ...
                (sample_vector(3)*PCp * CSEg) / (1-exp(-(sample_vector(3)/Alpha))) + ... 
                (sample_vector(4)*PCa * CSEg) / (1-exp(-(sample_vector(4)/Alpha))) + ...
                Intergrated_COM*CCOM*1000 + Intergrated_LIQ*CLIQ *1000+ Intergrated_CG*CCG*1000 + Intergrated_CL*CCL*1000;

        master_cost_list = [master_cost_list;sample_vector,cost];
    end
    
    [M, I] = min(master_cost_list(:, end));

    Rep_HPR(k) = master_cost_list(I,1);
    Rep_HAR(k) = master_cost_list(I,2);
    Rep_HPE(k) = master_cost_list(I,3);
    Rep_HAE(k) = master_cost_list(I,4);

end

% In intersection

Rep_HPR_int =[];
Rep_HAR_int =[];
Rep_HPE_int =[];
Rep_HAE_int =[];

master_cost_list = [];

for p = 1 : sample_num
    sample_vector = [HPR_list_int(p),HAR_list_int(p),HPE_list_int(p),HAE_list_int(p)];

    cost = (sample_vector(1)*PCp * CSEv / SEv) / (1-exp(-(sample_vector(1)/Alpha))) + ...
            (sample_vector(2)*PCa * CSEv / SEv) / (1-exp(-(sample_vector(2)/Alpha))) + ...
            (sample_vector(3)*PCp * CSEg) / (1-exp(-(sample_vector(3)/Alpha))) + ... 
            (sample_vector(4)*PCa * CSEg) / (1-exp(-(sample_vector(4)/Alpha))) + ...
            Intergrated_COM*CCOM*1000 + Intergrated_LIQ*CLIQ *1000+ Intergrated_CG*CCG*1000 + Intergrated_CL*CCL*1000;

    master_cost_list = [master_cost_list;sample_vector,cost];
end

[M, I] = min(master_cost_list(:, end));

Rep_HPR_int = master_cost_list(I,1);
Rep_HAR_int = master_cost_list(I,2);
Rep_HPE_int = master_cost_list(I,3);
Rep_HAE_int = master_cost_list(I,4);

%% Scenario sample integration process - frist stage

Intergrated_HPR = mean([sum(De_ksi_prob(t,:) .* Rep_HPR) Rep_HPR_int]);
Intergrated_HAR = mean([sum(De_ksi_prob(t,:) .* Rep_HAR) Rep_HAR_int]);
Intergrated_HPE = mean([sum(De_ksi_prob(t,:) .* Rep_HPE) Rep_HPR_int]);
Intergrated_HAE = mean([sum(De_ksi_prob(t,:) .* Rep_HAE) Rep_HAE_int]);

%% [HPR HAR HPE HAE]
Hydrogen_production_of_first_iteration = [Intergrated_HPR Intergrated_HAR Intergrated_HPE Intergrated_HAE]