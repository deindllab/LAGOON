N = size(U,2);
wind =10;
start =2;
Cy3_1 = zeros(N,1);
% Cy3_2 = zeros(N,1);
Cy5_1 = zeros(N,1);
Cy5_1_corr = zeros(N,1);
% Cy5_2 = zeros(N,1);
% Cy7_1 = zeros(N,1);
% Cy7_1_corr = zeros(N,1);
% Cy7_2 = zeros(N,1);
% FRET_Cy5 = zeros(N,1);
FRET_Cy3 = zeros(N,1);
Cy5DE = 0.103;

Treshold = 5;



for i=1:size(U,2)  %subtract background and create new 2 dimensional array for working
    Cy3_B(i) = mean(U(1,i).Cy3_1(2));
    Cy5_B(i) = mean(U(1,i).Cy5_1(2));
    Cy3_BG(i) = mean(U(1,i).Cy3_1(22));
    Cy5_BG(i) = mean(U(1,i).Cy5_1(22));
  
 
     if ((Cy3_BG(i)+Cy5_BG(i)) < 0.3*(Cy5_B(i)+Cy3_B(i))) 
        Cy3_B(i) = Cy3_B(i) - Cy3_BG(i);
        Cy5_B(i) = Cy5_B(i) - Cy5_BG(i);
        FRET_B(i) = Cy5_B(i)/(Cy3_B(i)+Cy5_B(i));
        
    else
        FRET_B(i) = -5;
       
    end
  
end 




%FRET_Cy3_before = FRET_Cy3_before(FRET_Cy3_before<1.2&FRET_Cy3_before>-0.2);
%FRET_Cy3_after = FRET_Cy3_after(FRET_Cy3_after<1.2&FRET_Cy3_after>-0.2);
% FRET_Cy5 = FRET_Cy5(FRET_Cy5<1.2&FRET_Cy5>-0.2);
    

figure();
% subplot(2,1,1);
histogram( FRET_B, -0.2:0.05:1.2);
title('Cy3 FRET After ');
%figure();
%histogram(FRET_A, -0.2:0.05:1.2);
%title('Cy3 FRET after');
% subplot(2,1,2);
% histogram(FRET_Cy5, -0.2:0.05:1.2);
% title('Cy5 FRET');
