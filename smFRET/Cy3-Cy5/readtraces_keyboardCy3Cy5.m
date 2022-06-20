function readtraces_keyboard

clear all;
B=2;
C=2;
A=1;
sort_wrap = 0;
n_thr = 50;
Cy5_thr = 10000;

%function for processing keyboard input when choosing what to do with a
%molecule
function key_pressed_fcn(fig_obj,eventDat)
        switch eventDat.Key
            case 'f' 
                B = 1;
                delete(gcf);
            case 'd' 
                B = 2;
                delete(gcf);
            case 's' 
                B = 3;
                delete(gcf);
            case 'a' 
                B = 4;
                delete(gcf);
            case 'r'
                B = 6;
                delete(gcf);
        end
           
end
%function for processing keyboard input when choosing whether to accept a
%trace
function key_pressed_fcn2(fig_obj,eventDat)
        switch eventDat.Key
            case 'f' 
                C = 1;
                delete(gcf);
            case 'd' 
                C = 2;
                delete(gcf);
            
        end
           
end

function key_pressed_fcn3(fig_obj,eventDat)
        switch eventDat.Key
            case 'f' 
                A = 2;
                delete(gcf);
            case 'd' 
                A = 1;
                delete(gcf);
            case 's' 
                A = 2;
                delete(gcf);
            case 'a' 
                A = 4;
                delete(gcf);
            
        end
           
end
    %1 = Analyze molecule
    %2 = Next molecule
    %3 = Previous molecule
    %4 = Accept molecule
    %functions for button clicks when choosing what to do with a molecule
    function callback1(fig_obj,eventDat)
        B=1;
        delete(gcf);
    end
    
    function callback2(fig_obj,eventDat)
        B=2;
        delete(gcf);
    end
    
    function callback3(fig_obj,eventDat)
        B=3;
        delete(gcf);
    end
    
    function callback4(fig_obj,eventDat)
        B=4;
        delete(gcf);
    end
    
    function callback5(fig_obj,eventDat)
        B=5;
        delete(gcf);
    end

    function callback6(fig_obj,eventDat)
        B=6;
        delete(gcf);
    end
    %funcitons for button clicks when choosing wether to save a trace
    function callback1_1(fig_obj,eventDat)
        C=1;
        delete(gcf);
    end
    
    function callback1_2(fig_obj,eventDat)
        C=2;
        delete(gcf);
    end
    
    function callback2_1(fig_obj,eventDat)
        A=2;
        delete(gcf);
    end
    
    function callback2_2(fig_obj,eventDat)
        A=1;
        delete(gcf);
    end
    function callback2_3(fig_obj,eventDat)
        A=2;
        delete(gcf);
    end
    function callback2_4(fig_obj,eventDat)
        A=4;
        delete(gcf);
    end
    

fretthreshold = 10000; % this is a threshold value to prevent crazy fret traces
%%%%%%%%% First read in file from directory - either .traces or .mat
%WD = cd;

fileID = fopen('lastFolder.txt');
A = fread(fileID,'*char')';
fclose(fileID);
% disp(A);

%[fileName,path1] = uigetfile({'*.traces;*.mat'},'Read Traces File');
[fileName,path1] = uigetfile({[A '\*.traces']},'Read Traces File');
fileName_temp=fileName;
fileName_temp=fileName_temp(1:length(fileName_temp)-7);

%if the user changed the directory, save it here...
lastFolderFile = fopen('lastFolder.txt','w')
fprintf(lastFolderFile,'%s',path1)
fclose(lastFolderFile)
% disp(path1);
% disp(length(path));
addpath(path1);  %add path to path list each time to ensure proper file access

FID = fopen(fileName);

k = strfind(fileName,'.traces');  % should be empty if .mat file was chosen
fretthreshold = 100;
FRETmin = -2;
FRETmax = 2;

% read in traces file if it was selected
if k
    %find number of frames and peaks from traces header file
    [n_fr,z1]       = fread(FID,1,'int32');      %z1 is just the number of indicated data types read (should be 1)
    [n_traces,z2]   = fread(FID,1,'int16');
    
    %intial user input and variables
    prompt      = {'Enter frame rate [Hz]:',...
        'Starting Molecule:',...
        'Flow Start Frame [0 to ignore]:',...
        'ALEX sequence (obsolete)',...
        'Cy5 leakage to Cy7',...
        'Cy3 leakage to Cy5',...
        'FRET interval [MIN MAX]',...
        'Photobleach criteria',...
        'Cy7 direct excitation',...
        'Cy7 to Cy5 scaling',...
        'Cy3 to Cy5 scaling',...
        'FRET limit'};
    dlg_title   = 'Initial Input';
    num_lines   = 1;
    def         = {'2','1','0','1 2','0.074','0.097','0.6 2','2000','0.25','0.291','0.703','2'}; %1.205 for nucleosomes, 0.703 for helicaes 2020-11-23
    input_ans   = inputdlg(prompt, dlg_title, num_lines, def);
    rate_fr     = str2num(input_ans{1});
    i           = str2num(input_ans{2});
    i_t=i;
    flow        = str2num(input_ans{3});
    sel         = char(input_ans{4});
    sel         = str2num(sel);
    Cy5Leak     = str2double(input_ans{5});
    Cy3Leak     = str2double(input_ans{6});
    FMM         = char(input_ans{7});
    FMM         = str2num(FMM);
    FRETmin     = FMM(1);
    FRETmax     = FMM(2);
    fretthreshold       = str2num(input_ans{8});
    dirCy7 = str2num(input_ans{9});
    Cy7Scale = str2num(input_ans{10});
    Cy3Scale = str2num(input_ans{11});
    FRETlim = str2num(input_ans{12});
    n_peaks     = n_traces/3;
    exp_length  =  n_fr/rate_fr; %(seconds)
    time        = (1/rate_fr:(1/rate_fr):exp_length);
    %%% Set up a parameters for indicating the flow starting point on each trace
    if flow
        flow_start = flow/rate_fr; % Flow start in seconds
    end
    wash = 100; % Wash time in seconds, e.g 100 for frame 50 at 0.5 Hz
    
    %% ALEX % sel=[1 1 2]; % 1 is green and 2 is red
    
    %% Now read in the rest of the data from the traces file and set more variables
    
    [total_data,z3]                 = fread(FID,[n_traces+1,n_fr],'int32');
    fclose1                          = (FID);
    total_data                      = total_data(2:n_traces,1:n_fr);   % this gets rid of the frame number col, which is the first colum in a traces file
    
%     SDA                             = size(total_data);
    
    total_Cy3                       = [];
    total_Cy5                       = [];
    total_Cy7                       = [];
    
    total_Cy3(1:n_peaks-2,1:n_fr)   = total_data(3*(0:n_peaks-3)+1,1:n_fr);     % remember matlab starts arrays at 1
    total_Cy5(1:n_peaks-2,1:n_fr)   = total_data(3*(0:n_peaks-3)+2,1:n_fr);
    total_Cy7(1:n_peaks-2,1:n_fr)   = total_data(3*(0:n_peaks-3)+3,1:n_fr);
    
    total_Cy3_1 = zeros(n_peaks, n_fr);
    total_Cy3_2 = zeros(n_peaks, n_fr);
    total_Cy5_1 = zeros(n_peaks, n_fr);
    total_Cy5_2 = zeros(n_peaks, n_fr);
    total_Cy7_1 = zeros(n_peaks, n_fr);
    total_Cy7_2 = zeros(n_peaks, n_fr);

    accepted_traces_1 = []; % an array to hold good molecule data for future analysis
    accepted_traces_2 = [];

    n_peaks = n_peaks-1;
    
    
    %% ----------------------------------------------------
    while i < n_peaks
        total_Cy3_temp              = total_Cy3(i,:);
        total_Cy3_1(i,:)            = total_Cy3_temp;
        total_Cy3_2(i,:)            = zeros(1,n_fr);
        
        total_Cy5_temp              = total_Cy5(i,:);
        total_Cy5_1(i,:)            = total_Cy5_temp;
        total_Cy5_2(i,:)            = zeros(1,n_fr);
        
        total_Cy7_temp              = total_Cy7(i,:);
        total_Cy7_1(i,:)            = total_Cy7_temp;
        total_Cy7_2(i,:)            = zeros(1,n_fr);
        

        time_1                      = time;
        time_2                      = time;

        total_Cy3_t1(i,:)           = total_Cy3_1(i,:);
        total_Cy5_t1(i,:)           = total_Cy5_1(i,:);
        total_Cy7_t1(i,:)           = total_Cy7_1(i,:);

        total_Cy3_t2(i,:)           = total_Cy3_2(i,:);
        total_Cy5_t2(i,:)           = total_Cy5_2(i,:);
        total_Cy7_t2(i,:)           = total_Cy7_2(i,:);

        i                           = i+1;
    end
    
    total_Cy3_1             = total_Cy3_t1;
    total_Cy5_1             = total_Cy5_t1;
    total_Cy7_1             = total_Cy7_t1;

    
%     Red excitation corrections
    total_Cy3_2             = total_Cy3_t2;
    total_Cy5_2             = total_Cy5_t2/(1-Cy5Leak); %Correcting Cy5 leakage
    total_Cy7_2             = (total_Cy7_t2-Cy5Leak*total_Cy5_2)/Cy7Scale; %Correcting Cy5 leakage and scaling to Cy5
    total_Cy7_2             = (total_Cy7_2-dirCy7*total_Cy5_2)/(1+dirCy7); %Correcting direct Cy7 excitation
%     FCy5Cy7 = total_Cy7_2./(total_Cy7_2+total_Cy5_2); %Calculating Cy5 to Cy7 FRET to be used when correcting green excitation traces
    
%     Green excitation corrections
    total_Cy3_1             = total_Cy3_1/(1-Cy3Leak);
    total_Cy5_1             = (total_Cy5_1-total_Cy3_1*Cy3Leak)/(1-Cy5Leak);
    total_Cy7_1             = total_Cy7_1-total_Cy5_1*Cy5Leak;
    
    total_Cy3_1             = total_Cy3_1/Cy3Scale;
    total_Cy7_1             = total_Cy7_1/Cy7Scale;


    i                       = i_t;
    %% ----------------------------------------------------
    
    
else  %%%%%%%%%%%%%% if .mat file is chosen, most variables already exist %%%%%%%%%%%%%%%
    FID = fopen(fileName);
    load(fileName,'accepted_traces_1','accepted_traces_2','time','time_1','time_2','exp_length','rate_fr');
    % need to reset n_peaks
    %     n = size(accepted_traces)
    %     n_fr
    n_peaks = size(accepted_traces_1,2)/3 + 1;   %add one to be consistent with n_peaks being off by +1
    %     at = accepted_traces(1,:)
    %     at = accepted_traces(1,3*(0:n_peaks-2)+1)
    %%%%%% now Cy3ct the data from the accepted_traces array and reformat in the total_Cy5, total _Cy7 format
    
    total_Cy3_1     = [];
    total_Cy5_1     = [];
    total_Cy7_1     = [];
    
    % total_Cy3(1:n_peaks-2,1:n_fr)     = total_data(3*(0:n_peaks-3)+1,1:n_fr);
    
    U_1 = size(accepted_traces_1(:,3*(0:n_peaks-2)+1)');
    U_2 = size(accepted_traces_2(:,3*(0:n_peaks-2)+1)');
    %   T1= size(1:n_peaks-1)
    %   T2= size(1:n_fr)
    
    total_Cy3_1(1:n_peaks-1,1:U_1(2))               = accepted_traces_1(:,3*(0:n_peaks-2)+1)';
    total_Cy5_1(1:n_peaks-1,1:U_1(2))               = accepted_traces_1(:,3*(0:n_peaks-2)+2)';
    total_Cy7_1(1:n_peaks-1,1:U_1(2))               = accepted_traces_1(:,3*(0:n_peaks-2)+3)';
    
    accepted_traces_1                               = [];  % now blank accepted traces for next round of analysis
    
    total_Cy3_2                                     = [];
    total_Cy5_2                                     = [];
    total_Cy7_2                                     = [];
    
    total_Cy3_2(1:n_peaks-1,1:U_2(2))               = accepted_traces_2(:,3*(0:n_peaks-2)+1)';
    total_Cy5_2(1:n_peaks-1,1:U_2(2))               = accepted_traces_2(:,3*(0:n_peaks-2)+2)';
    total_Cy7_2(1:n_peaks-1,1:U_2(2))               = accepted_traces_2(:,3*(0:n_peaks-2)+3)';
    accepted_traces_2                               = [];  % now blank accepted traces for next round of analysis
    
    
    %get user input and variables
    prompt    = {'Starting Molecule:','Flow Start Frame (0 to ignore):'};
    dlg_title = 'Initial Input';
    num_lines = 1;
    def       = {'1','0'};
    input_ans = inputdlg(prompt, dlg_title, num_lines, def);
    i         = str2num(input_ans{1});
    i_t=i;
    flow      = str2num(input_ans{2});
    %%% Set up a parameters for indicating the flow starting point on each trace
    if flow
        flow_start = flow/rate_fr;
    end
end

%% Weed out traces according to some criteria

    
ia=0;

%%iterate through all traces and apply the limits
i = 1;
while i < n_peaks
    total_Cy5_1_G = total_Cy5_1(i,:);
    total_Cy3_1_G = total_Cy3_1(i,:);
    dyesum_11 = total_Cy5_1_G + total_Cy3_1_G;
    FRET_t = total_Cy5_1_G./dyesum_11;
    FRET_t(dyesum_11<fretthreshold) = NaN;
%     %weed traces using both start and finish fluorescence intensity

    if k
        if (mean(FRET_t(1:10)) > FRETmin)&&(mean(FRET_t(1:10)) < FRETmax) % the average dyesum of the first ten frames is greater than some threshold
            if min(FRET_t) < FRETlim

                ia = ia+1;
                total_Cy5_1t(ia,:) = total_Cy5_1(i,:);
                total_Cy5_2t(ia,:) = total_Cy5_2(i,:);
                total_Cy3_1t(ia,:) = total_Cy3_1(i,:);
                total_Cy3_2t(ia,:) = total_Cy3_2(i,:);
                total_Cy7_1t(ia,:) = total_Cy7_1(i,:);
                total_Cy7_2t(ia,:) = total_Cy7_2(i,:); 
            end
        end
    else
        ia = ia+1;
        total_Cy5_1t(ia,:) = total_Cy5_1(i,:);
        total_Cy5_2t(ia,:) = total_Cy5_2(i,:);
        total_Cy3_1t(ia,:) = total_Cy3_1(i,:);
        total_Cy3_2t(ia,:) = total_Cy3_2(i,:);
        total_Cy7_1t(ia,:) = total_Cy7_1(i,:);
        total_Cy7_2t(ia,:) = total_Cy7_2(i,:); 
    end
    i=i+1;
end

%overwrite the original data
total_Cy5_1 = total_Cy5_1t;
total_Cy5_2 = total_Cy5_2t;
total_Cy3_1 = total_Cy3_1t;
total_Cy3_2 = total_Cy3_2t;
total_Cy7_1 = total_Cy7_1t;
total_Cy7_2 = total_Cy7_2t;

n_peaks = ia;

i = i_t;


%% create the figure window and place in specified location on screen the handle for this figure is 'h'
if i < n_peaks
    h = figure('Position', [7 100 1600 500]);
    %     h = figure('Position', [7 300 1652 504]);
end

%this while loop will continue until last trace in file is viewed
first = 1;
while i < n_peaks
    
%     st=size(total_Cy5_1(i,:));
%     sn=n_peaks;
%     ii=i;
    
   set(h,'Name',strcat('Molecule #',num2str(i),'/', num2str(n_peaks), ' Picked molecules #',num2str(size(accepted_traces_1,2)/3)));

    
%     if vsel_1 ~= 0
        if first
            first = 0;
            subplot(2,1,1);
            Cy5_plot = plot(time_1, total_Cy5_1(i,:),'r');
            hold on
            xlabel('Time, seconds')
            xlim([0 exp_length])
            ylabel('Intensity')
            title('Green excitation')
            grid on


            Cy3_plot = plot(time_1, total_Cy3_1(i,:),'g');
            legend('Cy5','Cy3')
            %     ,'Location','NorthEastOutside'
        if flow
            
%             vline(flow_start,'-k');
            tempT = flow_start;
            maxt = time_1(end);
            while tempT<maxt
                vline(tempT,':k');
                tempT = tempT+flow_start;
            end
        end
        
               
        hold off
        
        subplot(2,1,2)
        dyesum_11 = total_Cy5_1(i,:)+total_Cy3_1(i,:);
         [rows] = find(dyesum_11 <fretthreshold);
        FRET_11 = total_Cy5_1(i,:)./dyesum_11;

        
        dyesum_12 = total_Cy5_1(i,:)+total_Cy3_1(i,:);

        FRET_12 = total_Cy5_1(i,:)./dyesum_12;
        FRET_11(rows) = 0;
        
        FRET_plot = plot(time_1, FRET_11,'k')
        legend('Cy5/(Cy5+Cy3)')
        xlabel('Time, seconds')
        ylabel('FRET')
        ylim([-.4 1.4])
        set(gca,'ytick',-.4:.2:1.4)
        xlim([0 exp_length])
        grid on
        if flow
            hold on
%             vline(flow_start,'-k');
            tempT = flow_start;
            maxt = time_1(end);
            while tempT<maxt
                vline(tempT,':k');
                tempT = tempT+flow_start;
            end
            hold off
        end
        hold off
        else
            Cy5_plot.YData = total_Cy5_1(i,:);
            Cy3_plot.YData = total_Cy3_1(i,:);
            dyesum_11 = total_Cy5_1(i,:)+total_Cy3_1(i,:);
            [rows] = find(dyesum_11 <fretthreshold);
            FRET_11 = total_Cy5_1(i,:)./dyesum_11;
            dyesum_12 = total_Cy5_1(i,:)+total_Cy3_1(i,:);
            FRET_12 = total_Cy5_1(i,:)./dyesum_12;
            FRET_11(rows) = 0;
            FRET_plot.YData = FRET_11;
        end
        
%     end
    B = 2;
            
    %1 = Analyze molecule
    %2 = Next molecule
    %3 = Previous molecule
    %4 = Accept molecule
    
    d = dialog('Position',[100 800 130 240],'Name','My Dialog');

        txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[5 200 120 30],...
           'String','Analyze this molecule?');
        btn = uicontrol('Parent',d,...
           'Position',[5 170 120 30],...
           'String','Yes (f)',...
           'Callback',@callback1);
        btn = uicontrol('Parent',d,...
           'Position',[5 140 120 30],...
           'String','Next (d)',...
           'Callback',@callback2);
        btn = uicontrol('Parent',d,...
           'Position',[5 110 120 30],...
           'String','Previous (s)',...
           'Callback',@callback3);
        btn = uicontrol('Parent',d,...
           'Position',[5 80 120 30],...
           'String','Accept (a)',...
           'Callback',@callback4);
        btn = uicontrol('Parent',d,...
           'Position',[5 50 120 30],...
           'String','Save fig (r)',...
           'Callback',@callback6);
        btn = uicontrol('Parent',d,...
           'Position',[5 20 120 30],...
           'String','End program',...
           'Callback',@callback5);
    
    
    d.KeyPressFcn=@key_pressed_fcn;
    uiwait(d);
    
    
%     B = menu('analyze this molecule?', 'yes', 'next' , 'previous', 'accept.', 'end program');
    
    if B == 1;
        
        
%         A = menu('Which dye molecule bleached', 'Cy7', 'Cy5', 'Cy5 & Cy7', 'Cy3, Cy5 & Cy7', 'Neither');
        A=2;
            
           
        if A == 2; %both Cy3 and Cy7
            [x,y] = ginput(2);
            %%% prevent program from crashing if area outside graph is clicked
            if (x(2) > exp_length) || (x(1) < 0)
                while (x(2) > exp_length) || (x(1) < 0)
                    %                     'Try again - reclick both points'
                    [x,y] = ginput(2);
                end
                ...
                    
            end
            
            x1_1 = round(x(1)*rate_fr);   %round after multiplying to get closer to actual frames selected
            x2_1 = round(x(2)*rate_fr);
            x1_2 = round(x(1)*rate_fr);
            x2_2 = round(x(2)*rate_fr);
            
            %             x1_1 = round(x(1)*rate_fr*vsel_1);
            %             x2_1 = round(x(2)*rate_fr*vsel_1);
            %             x1_2 = round(x(1)*rate_fr*vsel_2);
            %             x2_2 = round(x(2)*rate_fr*vsel_2);
            
            norm_1            = mean(total_Cy7_1(i,x1_1:x2_1)) - 0;
            Cy7_norm_1   = total_Cy7_1(i,:)-norm_1;
            
            norm_1            = mean(total_Cy5_1(i,x1_1:x2_1)) - 0;
            Cy5_norm_1      = total_Cy5_1(i,:)-norm_1;
            
            norm_1            = mean(total_Cy3_1(i,x1_1:x2_1)) - 0;
            Cy3_norm_1      = total_Cy3_1(i,:)-norm_1;
            
            norm_2            = mean(total_Cy7_2(i,x1_2:x2_2)) - 0;
            Cy7_norm_2   = total_Cy7_2(i,:)-norm_2;
%             
            norm_2            = mean(total_Cy5_2(i,x1_2:x2_2)) - 0;
            Cy5_norm_2      = total_Cy5_2(i,:)-norm_2;
            
            norm_2            = mean(total_Cy3_2(i,x1_2:x2_2)) - 0;
            Cy3_norm_2      = total_Cy3_2(i,:)-norm_2;
            
            
            Cy5_plot.YData = Cy5_norm_1;
            Cy3_plot.YData = Cy3_norm_1;
            dyesum_11 = Cy5_norm_1+Cy3_norm_1;
            FRET_11 = Cy5_norm_1./dyesum_11;
            FRET_plot.YData = FRET_11;
                    
%             C = menu('Accept this trace', 'yes', 'no');
            C=2;
            
            d = dialog('Position',[100 800 130 100],'Name','My Dialog');

                txt = uicontrol('Parent',d,...
                    'Style','text',...
                    'Position',[5 70 120 20],...
                    'String','Save this trace?');
                btn = uicontrol('Parent',d,...
                    'Position',[5 40 120 30],...
                    'String','Yes (f)',...
                    'Callback',@callback1_1);
                btn = uicontrol('Parent',d,...
                    'Position',[5 10 120 30],...
                    'String','No (d)',...
                    'Callback',@callback1_2);
            d.KeyPressFcn=@key_pressed_fcn2;
            uiwait(d);
            
            if C == 1;
                    
                    accepted_traces_1 = [accepted_traces_1 Cy3_norm_1' Cy5_norm_1' Cy7_norm_1'];
                    accepted_traces_2 = [accepted_traces_2 Cy3_norm_2' Cy5_norm_2' Cy7_norm_2'];

            end
            
        elseif A==4; %none
%             C = menu('Accept this trace', 'yes', 'no');
            C=2;
            
            d = dialog('Position',[100 800 130 100],'Name','My Dialog');

                txt = uicontrol('Parent',d,...
                    'Style','text',...
                    'Position',[5 70 120 20],...
                    'String','Save this trace?');
                btn = uicontrol('Parent',d,...
                    'Position',[5 40 120 30],...
                    'String','Yes (f)',...
                    'Callback',@callback1_1);
                btn = uicontrol('Parent',d,...
                    'Position',[5 10 120 30],...
                    'String','No (d)',...
                    'Callback',@callback1_2);
            d.KeyPressFcn=@key_pressed_fcn2;
            uiwait(d);
            
            if C == 1
                    accepted_traces_1 = [accepted_traces_1 total_Cy3_1(i,:)' total_Cy5_1(i,:)' total_Cy7_1(i,:)'];
                    accepted_traces_2 = [accepted_traces_2 total_Cy3_2(i,:)' total_Cy5_2(i,:)' total_Cy7_2(i,:)'];

            end
        end
        
        i = i+1;
        
    elseif B == 2;
        i = i+1;
        
    elseif B == 3;
        i = i-1;
        
    elseif B == 4;
       
            accepted_traces_1 = [accepted_traces_1 total_Cy3_1(i,:)' total_Cy5_1(i,:)' total_Cy7_1(i,:)'];
            accepted_traces_2 = [accepted_traces_2 total_Cy3_2(i,:)' total_Cy5_2(i,:)' total_Cy7_2(i,:)'];
        i = i+1;
    elseif B == 5;
        break
    
    elseif B == 6;
        saveas(gcf, strcat(path1,fileName, '_trace_', num2str(i), '.fig'));
        i = i+1;
    end
end

% if ~COMMON_START_FILTER
%     close(h);
%     % wait_times
% end

%%% Create the FRET_traces variable
if ~isempty(accepted_traces_1)
    Cy3_1  = [];
    Cy5_1  = [];
    Cy7_1  = [];
    dyesum_1 = [];
    FRET_traces_1 = [];
    num_accep_traces_1 = size(accepted_traces_1,2)/3;
    for i = 1:num_accep_traces_1
        Cy3_1   = accepted_traces_1(:,3*i-2);
        Cy5_1   = accepted_traces_1(:,3*i-1);
        Cy7_1   = accepted_traces_1(:,3*i);
        dyesum_1  = Cy5_1 + Cy3_1;
        [rows]  = find(dyesum_1 < fretthreshold);
        FRET_traces_1(:,i) = Cy5_1./dyesum_1;
        FRET_traces_1(rows,i) = 0;
    end
else
    FRET_traces_1 = 0;
end

if ~isempty(accepted_traces_2)
    Cy3_2  = [];
    Cy5_2  = [];
    Cy7_2  = [];
    dyesum_2 = [];
    FRET_traces_2 = [];
    num_accep_traces_2 = size(accepted_traces_2,2)/3;
    for i = 1:num_accep_traces_2
        Cy3_2   = accepted_traces_2(:,3*i-2);
        Cy5_2   = accepted_traces_2(:,3*i-1);
        Cy7_2   = accepted_traces_2(:,3*i);
        dyesum_2  = Cy5_2 + Cy7_2;
        [rows]  = find(dyesum_2 < fretthreshold);
        FRET_traces_2(:,i) = Cy7_2./dyesum_2;
        FRET_traces_2(rows,i) = 0;
    end
else
    FRET_traces_2 = 0;
end

%% save all data in workspace for later manipulation

r = menu('Would you like to save this workspace?','yes','no');


close(h)

  clear dyesum_1... 
  dyesum_11...
  dyesum_2...
  fclose...    
  fileName_temp...
  filtered_Cy3_1...
  filtered_Cy5_1...
  filtered_Cy7_1...
  n_thr...
  Cy7_thr...

clear total_Cy3...
  total_Cy3_1...
  total_Cy3_1t...
  total_Cy3_2... 
  total_Cy3_2t...
  total_Cy3_t1...
  total_Cy3_t2...
  total_Cy3_temp...
  total_Cy5...     
  total_Cy5_1...   
  total_Cy5_1_G... 
  total_Cy7_1_G... 
  total_Cy7_1_R... 
  total_Cy5_1t...
  total_Cy5_2... 
  total_Cy5_2t...
  total_Cy5_t1...
  total_Cy5_t2...
  total_Cy5_temp...
  total_Cy7...
  total_Cy7_1...
  total_Cy7_1t...
  total_Cy7_2... 
  total_Cy7_2t...
  total_Cy7_t1...
  total_Cy7_t2...
  total_Cy7_temp...
  total_data...
  d...
  txt...
  btn...



if r == 1
    %     uy=path1
    %     cd(path1);
    [file,path2,filterindex] = uiputfile(strcat(path1,fileName(1:length(fileName)-7),'.mat'),fileName);
    %filterindex is set to zero if cancel button is clicked (or an error occurs), otherwise it's 1
    if filterindex
        save_file_name = strcat(path2,file);
        % Ugly try-catch solution to ugly problem...
        saved = 0;
        while saved == 0;
        try
        disp(['Attempting to save file:' save_file_name]);
        save(save_file_name);
        saved = 1;
        catch
        warning('Problem saving, retry saving...')
        pause(.5);
        end;
        end;
       
    end
    %     cd(WD);
end
% clearvars
end