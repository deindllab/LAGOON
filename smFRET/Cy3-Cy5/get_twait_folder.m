

fileID = fopen('lastFolder.txt');
A = fread(fileID,'*char')';
fclose(fileID);
disp(A);

if A 
    path1 = uigetdir(A,'Read trace files');
else path1 = uigetdir('Read trace files');
end
%files = fuf([path1 '\*.mat'],'detail'); %Windows
files = fuf([path1 '/*.mat'],'detail'); %Mac
n_files = size(files,1);
deltaFRET_comb{n_files}= [];
ave_FRET_speed_comp{n_files} = [];
region_time_comb{n_files} = [];
max_int_comp{n_files} = [];
N = zeros(n_files,1);
speed_ave=zeros(n_files,1);
speed_SD=zeros(n_files,1);
speed_SEM=zeros(n_files,1);

            
for k = 1:n_files
    clear U;
    load(files{k},'U');
    ave_win_size = 1;
    med_win_size = 1;

    twait = [];
    FRET1 = [];
    FRET2 = [];

    deltaFRET = [];
    Max_int = [];


for i=1:size(U,2)
%for i = 1:30
    %current_trace = smooth(U(1,i).FRET,ave_win_size,'moving');
%     current_trace = medfilt1(U(1,i).FRET,med_win_size);
    time = U(1,i).time_1;
%     flow = U(1,i).flow;
    Cy3 = U(1,i).Cy3_1;
    Cy5 = U(1,i).Cy5_1;
    Int = Cy3+Cy5;
    %current_trace = smooth(U(1,i).donor,ave_win_size,'moving');
    end_fr = size(time,1);
    
    if U(1,i).click_frames
        for j=1:length(U(1,i).click_frames)/2
          start = U(1,i).click_frames(1,j*2-1);
          stop = U(1,i).click_frames(1,j*2);
          start = max([start 1]);
          stop = min([stop length(Cy3)]-2);
%           region = current_trace(start:stop,1);
          region_time = time(1,stop) - time(1,start);
            F1 = Cy5(start)/(Cy3(start)+Cy5(start));
%           F2 = Cy5(stop)/(Cy3(stop)+Cy5(stop));
          F1 = mean(Cy5(start-2:start+2)./(Cy3(start-2:start+2)+Cy5(start-2:start+2)));
          F2 = mean(Cy5(stop-2:stop+2)./(Cy3(stop-2:stop+2)+Cy5(stop-2:stop+2)));
          F_med = medfilt1(Cy5./Int, 5);
          F_med_der = diff(F_med);
          dFRET = F1 - F2;
          FRET1 = [FRET1 F1];
          FRET2 = [FRET2 F2];
          if (dFRET>0.2)&(region_time>0) %Added a threshold for a FRET derivative to exclude weird traces
          deltaFRET = [deltaFRET dFRET];
          twait = [twait region_time];
          Max_int = [Max_int mean(Int(1:10))];
%         
          end
        end 
    end
end
ave_FRET_speed = deltaFRET./twait; % Average speed of FRET change in FRET units per second
% num = 7;
speed_ave(k) = mean(ave_FRET_speed);
speed_SD(k) = std(ave_FRET_speed);
speed_SEM(k) = std(ave_FRET_speed)/sqrt(length(ave_FRET_speed));
deltaFRET_comb{k}= deltaFRET;
ave_FRET_speed_comp{k} = ave_FRET_speed;
region_time_comb{k} = region_time;
max_int_comp{k} = Max_int;
N(k) = length(ave_FRET_speed);
% histogram(ave_FRET_speed,0:0.02:1);

clear A...
    ave_FRET_speed...
    Cy3...
    Cy5...
    ave_win_size...
    med_win_size...
    k...
    j...
    i...
    Int...
    dFRET...
    end_fr...
    deltaFRET...
    F1...
    F2...
    Max_int...
    n_files...
    path1... 
    region_time...
    start...
    stop...
    time...
    twait...
    U...
    fileID...
    FRET1...
    FRET2

end