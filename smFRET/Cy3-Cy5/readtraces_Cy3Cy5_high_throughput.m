%For reference, a traces file looks like this:
%32bit signed int --> # of frames
%16bit signed int --> # of traces
%2D array of 32bit unsigned ints --> this is50 the data see below for format
%n x m matrix (say n rows by m columns)
%n --> # of traces plus 1 (because the first row contains the frame #)
%m --> # of frames 
%}

warning off all
clear all;
fileName = 'slope_Struct.mat';

fileID = fopen('lastFolder.txt');
A = fread(fileID,'*char')';
fclose(fileID);
disp(A);

if A 
    path1 = uigetdir(A,'Read trace files');
else path1 = uigetdir('Read trace files');
end
files = fuf([path1 '\*.traces'],'detail');

lastFolderFile = fopen('lastFolder.txt','w');
fprintf(lastFolderFile,'%s',path1);
fclose(lastFolderFile);

prompt      = {'Enter frame rate [Hz]:',...
    'Cy3 leakage to Cy5',...
    'Cy5 leakage to Cy7',...
    'FRET interval [MIN MAX]',...
    'Cy3 to Cy5 scaling',...
    'Min length before PB, frames (0=off)',...
    'Min FRET change (0=off)'};
dlg_title   = 'Initial Input';
num_lines   = 1;
def         = {'5','0.0676','0.097','0.7 2','0.492','30', '0.2'}; %1.205 for nucleosomes, 0.703 for helicaes 2020-11-23

input_ans   = inputdlg(prompt, dlg_title, num_lines, def);
rate_fr     = str2num(input_ans{1});
Cy5Leak     = str2double(input_ans{2});
Cy3Leak     = str2double(input_ans{3});
FMM         = char(input_ans{4});
FMM         = str2num(FMM);
FRETmin     = FMM(1);
FRETmax     = FMM(2);
Cy3Scale = str2num(input_ans{5});
Min_length = str2num(input_ans{6});
Min_FRET_change = str2num(input_ans{7});


if ~isempty(files)
    for j = 1:size(files,1)
        k = strfind(files{j},'.traces');
        if ~k
            continue
        end
        U = [];
        FID = fopen(files{j});
        %find number of frames and peaks from traces header file
        [n_fr,z1]       = fread(FID,1,'int32');      %z1 is just the number of indicated data types read (should be 1)
        [n_traces,z2]   = fread(FID,1,'int16');
        n_peaks     = round(n_traces/2);
        exp_length  =  n_fr/rate_fr; %(seconds)
        time        = (1/rate_fr:(1/rate_fr):exp_length);
        reject_multi_bleach = [];
        reject_length = [];
        reject_FRETrange = [];
        reject_FRETchange = [];
        reject_norm = [];
        %% Now read in the rest of the data from the traces file and set more variables
        [total_data,z3] = fread(FID,[n_traces+1,n_fr],'int32');
        fclose1 = (FID);
        total_data = total_data(2:n_traces,1:n_fr);   % this gets rid of the frame number col, which is the first colum in a traces file

        total_Cy3 = total_data(2*(0:n_peaks-2)+1,1:n_fr);     % remember matlab starts arrays at 1
        total_Cy5 = total_data(2*(0:n_peaks-2)+2,1:n_fr);

        n_peaks = n_peaks-1; % I don't know why?


        %     Green excitation corrections
        total_Cy3             = total_Cy3/(1-Cy3Leak);
        total_Cy5             = (total_Cy5-total_Cy3*Cy3Leak)/(1-Cy5Leak);
        total_Cy3             = total_Cy3/Cy3Scale;
%         trimming first frames
        start_frame = 1;
        n_fr = n_fr +1 - start_frame;
        total_Cy3 = total_Cy3(:,start_frame:end);
        total_Cy5 = total_Cy5(:,start_frame:end);
        time = time(start_frame:end);

        max_int = zeros(n_peaks,1);
        window = 10;
        %%iterate through all traces and apply the limits
        i = 1;
        click_fr{n_peaks} = [];
        while i < n_peaks
            Cy5 = total_Cy5(i,:);
            Cy3 = total_Cy3(i,:);
            
            Int = Cy5 + Cy3;
            FRET = Cy5./Int;

        % Estimating the maximum intensity as average in tensity in the first
        % 10 frames

            Int_ave = smooth(Int,window,'moving');
            Cy3_ave = smooth(Cy3,window,'moving');
            Cy5_ave = smooth(Cy5,window,'moving');
    %         Max = quantile(Int_ave,0.95);
            Max = mean(Int(1:10));

        %     Is the trace normalizable? Intensity below 20% of maximum for at
        %     least 20 frames. If so, normalize the trace. If not - move on.

            [Min,I] = min(Int_ave);
        %         If the intensity drops below the 20% of initial value, 
        %         we use the minimum of the smoothed intensity as a
        %         baseline for normalizing

            if Min<0.5*Max 
                Length = length(Int);
                wind = round (window/2);
                left = max([1 I-wind]);
                right = min([Length I+wind]);
                SD = std(Int(left:right));
        %             Expandind the normalization boundaries until the difference
        %             in intensity exceeds 2 SDs or the end of array is reached
                while ((Int_ave(left)-Min)<2*SD)&&(left>1)
                    left = left -1;
                end
                while ((Int_ave(right)-Min)<2*SD)&&(right<Length)
                    right = right + 1;
                end

                left = min([left+5 I-wind]); % stepping 5 points away from the boundaries
                left = max([left 1]);
                right = max([right-5 I+wind]); 
                right = min([right Length]);
                Cy3 = Cy3 - mean(Cy3(left:right));
                Cy5 = Cy5 - mean(Cy5(left:right));
                Int = Cy5 + Cy3;
                Int_ave = smooth(Int,window,'moving');
                Max = mean(Int(1:10));
                max_int(i) = Max;
                FRET = Cy5./Int;
            end

                F = mean(FRET(1:10));
                thr_1 = 0.2*Max;
                FRET(Int<thr_1) = NaN;

                FRET_ave = medfilt1(FRET,3);
                 
                % locating the first point where FRET goes below starting value minus thr1
                % Ignoring the first 20 frames
                FRET_thr1 = 0.05;
                FRET_thr2 = 0.3;
                FRET_below_thr1 = find(FRET_ave<(F-FRET_thr1));
                FRET_above_thr = FRET_ave>FRETmin;
                FRET_decrease = FRET_above_thr(1:end-1)-FRET_above_thr(2:end);
                FRET_decrease_start = find(FRET_decrease==1);
                candidates = length(FRET_decrease_start);
                FRET_deriv = FRET_ave(2:end)-FRET_ave(1:end-1);
                FRET_inc = find(FRET_deriv>0);
                FRET_NAN = find(isnan(FRET));
%                 
%                 index = min(FRET_below_thr1(FRET_below_thr1>20));
                len = length(FRET_ave);
                lo = 0;
                for index = 1:candidates 
                  start = FRET_decrease_start(index);
                  start1 = max([FRET_inc(FRET_inc<start)+1 FRET_NAN(FRET_NAN<start)+1]);
                  start = min([start start1]);
                  if index>1
                      if start<FRET_decrease_start(index-1)
                          continue
                      end
                  end
                  F1 = FRET_ave(start);
                  stop = min([FRET_inc(FRET_inc>start) FRET_NAN(FRET_NAN>start) len]);
                  F2 = FRET_ave(stop);
                  if index<candidates
                      if stop>FRET_decrease_start(index+1)
                          continue
                      end
                  end
               
                    if (stop-start)>3 % an arbitrary threshold to exclude too short transitions
                        if Min_FRET_change
                            if (F1-F2)>Min_FRET_change
                                lo = 1;
                                click_fr{i} = [click_fr{i} start stop-1];
                    
                            end
                            
                        else
                            lo = 1;
                            click_fr{i} = [click_fr{i} start stop-1];
                    
                        end
                    end
                    
               
                end
                
                if ~lo
                    max_int(i) = 0;
                    reject_FRETchange = [reject_FRETchange i];
                end
                    
        %}
%             else
%                 max_int(i) = 0; 
%                 reject_norm = [reject_norm i];
%             end

            total_Cy5(i,:) = Cy5;
            total_Cy3(i,:) = Cy3;
            i = i+1;
        end

        %     Sorting the traces according to their intensity
        [max_int,I] = sort(max_int, 'descend');
        index = find(max_int>0);
        if index
            index = index(end);
        else 
            continue
        end
        %     Trimming the index array to leave only indexes with positive intensity
        I = I(1:index); 
        n_peaks = length(I);
        total_Cy5 = total_Cy5(I,:);
        total_Cy3 = total_Cy3(I,:);
        
        
        % Saving the structure
        U = repmat(struct(...   repmat will initialize each field in the structure array with the same value
                'Cy3_1',[],...       the processed extra value
                'Cy5_1',[],...       the processed donor value (usually normalized to bleached levels, but sometime nothing)
                'FRET_1',[],...        the FRET traces are calculated from donor and accept_corr above
                'time_1',time,...
                'fr_rt',rate_fr,...
                'num_fr',n_fr,...
                'fretthresh',0,...
                'info',files{j},...
                'click_frames',[]),1,n_peaks);  %num_accep_traces defines the size of the structure array
        FRET = total_Cy5./(total_Cy3+total_Cy5);
        for i = 1:n_peaks
                U(i).Cy3_1            = total_Cy3(i,:);
                U(i).Cy5_1            = total_Cy5(i,:);
                U(i).FRET_1           = FRET(i,:);
                U(i).fretthresh       = 0.2*max_int(i);
                U(i).click_frames     = click_fr{I(i)};
        end
        clear click_fr;
        saveFilename = files{j}(1:length(files{j})-7);
        disp(saveFilename);
        saveFilename = [saveFilename '_slope_U.mat'];
        disp(saveFilename);
        save(saveFilename,'U')
    end
else
    disp('No files found');
end
