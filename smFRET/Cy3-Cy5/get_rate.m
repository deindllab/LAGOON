ave_win_size = 1;
med_win_size = 1;

FRET1 = [];
FRET2 = [];
rate = [];
Max_int = [];

deltaFRET = [];
twait = [];


for i=1:size(U,2)
    time = U(1,i).time_1;
    Cy3 = U(1,i).Cy3_1;
    Cy5 = U(1,i).Cy5_1;
    Int = Cy3+Cy5;
    end_fr = size(time,1);
    
    for j=1:length(U(1,i).click_frames)/2
          start = U(1,i).click_frames(1,j*2-1);
          stop = U(1,i).click_frames(1,j*2);
          start = max([start 1]);
          stop = min([stop length(Cy3)]);
          region_time = time(1,stop) - time(1,start);
          F1 = Cy5(start)/(Cy3(start)+Cy5(start));
          F2 = Cy5(stop)/(Cy3(stop)+Cy5(stop));
          
          dFRET = F1 - F2;
          FRET1 = [FRET1 F1];
          FRET2 = [FRET2 F2];
          deltaFRET = [deltaFRET dFRET];
          twait = [twait region_time];
          Max_int = [Max_int mean(Int(1:10))];
         
    end
end
ave_FRET_speed = deltaFRET./twait; % Average speed of FRET change in FRET units per second
num = 1;
Y(num) = mean(ave_FRET_speed)
sdY(num) = std(ave_FRET_speed)
semY(num) = std(ave_FRET_speed)/sqrt(length(ave_FRET_speed))
SPEED = ave_FRET_speed';
histogram(ave_FRET_speed,0:0.02:1);