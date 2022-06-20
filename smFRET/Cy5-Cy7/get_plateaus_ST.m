hist_data = [];
FRET = NaN(size(U,2), 6);

for i=1:size(U,2)
    current_Cy5 = U(1,i).Cy5_1;
    current_Cy7 = U(1,i).Cy7_1;
    N = length(U(1,i).click_frames);
    if (N>3)&&(mod(N,2)==0)
        for j = 1:floor(N/2)
            
          start_1 = U(1,i).click_frames(2*j-1);
          stop_1 = U(1,i).click_frames(2*j);
        
          if start_1<1
              start_1 = 1;
          end
%           start_3 = U(1,i).click_frames(5);
%           stop_3 = U(1,i).click_frames(6);
          Cy5 = mean(current_Cy5(start_1:stop_1));
          Cy7 = mean(current_Cy7(start_1:stop_1));
          FRET(i,j+1) = Cy7/(Cy7+ Cy5);


        end
    
    else
        for j = 1:floor(N/2)
            
          start_1 = U(1,i).click_frames(2*j-1);
          stop_1 = U(1,i).click_frames(2*j);
        
          if start_1<1
              start_1 = 1;
          end
%           start_3 = U(1,i).click_frames(5);
%           stop_3 = U(1,i).click_frames(6);
          Cy5 = mean(current_Cy5(start_1:stop_1));
          Cy7 = mean(current_Cy7(start_1:stop_1));
          FRET(i,j) = Cy7/(Cy7+ Cy5);


        end
    end
end


subplot(5,2,1);
histogram(FRET(:,1),0:0.05:1);
title("Plateau 1");


subplot(5,2,2);
histogram(FRET(:,2)-FRET(:,1),0:0.02:0.7);
title("Step 1");

subplot(5,2,3);
histogram(FRET(:,2),0:0.05:1);
title("Plateau 2");


subplot(5,2,4);
histogram(FRET(:,3)-FRET(:,2),0:0.02:0.7);
title("Step 2");


subplot(5,2,5);
histogram(FRET(:,3),0:0.05:1);
title("Plateau 3");


subplot(5,2,6);
histogram(FRET(:,4)-FRET(:,3),0:0.02:0.7);
title("Step 3");


subplot(5,2,7);
histogram(FRET(:,4),0:0.05:1);
title("Plateau 4");


subplot(5,2,8);
histogram(FRET(:,5)-FRET(:,4),0:0.02:0.7);
title("Step 4");


subplot(5,2,9);
histogram(FRET(:,5),0:0.05:1);
title("Plateau 5");

subplot(5,2,10);
TDP = [FRET(:,1:2); FRET(:,2:3); FRET(:,3:4); FRET(:,4:5)]; 
TDP = TDP';
[N,Xedges,Yedges] = histcounts2(TDP(1,:),TDP(2,:),0:0.04:1,0:0.04:1);
Xedges = (Xedges(1:end-1)+Xedges(2:end))/2;
Yedges = (Yedges(1:end-1)+Yedges(2:end))/2;
contourf(Xedges,Yedges,N',100,'LineColor','none');
% histogram2(TDP(1,:),TDP(2,:),0:0.04:1,0:0.04:1,'FaceColor','flat');
colorbar;
title("Transition density plot");
% view(2);
hold on;
refline(1,0);
hold off;

