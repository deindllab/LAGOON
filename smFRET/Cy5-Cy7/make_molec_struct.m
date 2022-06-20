% Sebastian Deindl 2012-2014
% Goes through existing .mat file and organizes all the indicated variables into
% a structure called "U"
%
%clear all
%warning off MATLAB:divideByZero
%
%#######################################################
% Modifications made by Joakim Laksman May 2016 for 3 color FRET
% Takes all the *.mat files in one folder and combines them into
% a  *_struc.mat file which is a structure.
%#######################################################

warning off all

fileName = 'combinedStruct.mat'

if 1
    path1 = uigetdir('C:','Read normalized Files');
    files = fuf([path1 '\*.mat'],'detail');
else
    fileID = fopen('lastFolder.txt');
    A = fread(fileID,'*char')';
    fclose(fileID);
    disp(A);

    %[fileName,path1] = uigetfile({'*.mat'},'Read Structure Click File');
    [fileName,path1] = uigetfile(A,'Read normalised file');
    files = {} %an empty cell array
    files{1} = [[path1 fileName]];
    disp(size(files,1));
    disp(files);
    disp(files{1});
end

U_temp_1 = [];
U_temp_2 = [];

if ~isempty(files)
    for j = 1:size(files,1)
        %if ~isempty(who('-file',files{j},'U_1'))
        %    load(files{j},'U_1');
        %    molecules = U_1;
        %else
            raw_accept = 0;
            raw_donor = 0;
            leak = 0;
            FID = fopen(files{j})
            load(files{j},'accepted_traces_1','accepted_traces_2','FRET_traces_1','FRET_traces_2',...
                'rate_fr','n_fr','flow','fretthreshold','time_1','time_2');
            %,'num_accep_traces'...
            %,'click_points'...
            %);
            if ~isempty(who('-file',files{j},'accepted_raw_acceptor'))
                load(files{j},'accepted_raw_acceptor');
                raw_accept = 1;
            end
            if ~isempty(who('-file',files{j},'accepted_raw_donor'))
                load(files{j},'accepted_raw_donor');
                raw_donor = 1;
            end
            if ~isempty(who('-file',files{j},'leakage'))
                load(files{j},'leakage');
                leak = 1;
            end
            
            fclose(FID);
            
            num_accep_traces_1 = size(accepted_traces_1,2)/3;
            num_accep_traces_2 = size(accepted_traces_2,2)/3;
            
            molecules = repmat(struct(...   repmat will initialize each field in the structure array with the same value
                'Cy3_1',[],...       the processed extra value
                'Cy5_1',[],...       the processed donor value (usually normalized to bleached levels, but sometime nothing)
                'donor_raw_1',[],...   the raw, unprocessed donor signal
                'Cy7_1',[],... the processed acceptor value, corrected for donor leakage and often then normalized to bleached level
                'accept_raw_1',[],...  the raw, unprocessed acceptor signal
                'FRET_1',[],...        the FRET traces are calculated from donor and accept_corr above
                'time_1',time_1,...
                'fr_rt',rate_fr,...
                'num_fr',n_fr,...
                'flow',flow,...
                'fretthresh',fretthreshold,...
                'leakage_corr',[],...
                'info',files{j},...
                'click_frames',[],...
                'Cy3_2',[],...       the processed extra value
                'Cy5_2',[],...       the processed donor value (usually normalized to bleached levels, but sometime nothing)
                'donor_raw_2',[],...   the raw, unprocessed donor signal
                'Cy7_2',[],... the processed acceptor value, corrected for donor leakage and often then normalized to bleached level
                'accept_raw_2',[],...  the raw, unprocessed acceptor signal
                'FRET_2',[],...        the FRET traces are calculated from donor and accept_corr above
                'time_2',time_2,...
                'click_frames_2',[]),1,num_accep_traces_2);  %num_accep_traces defines the size of the structure array
            
            for i = 1:num_accep_traces_1
                molecules(i).Cy3_1            = accepted_traces_1(:,3*i-2);
                molecules(i).Cy5_1            = accepted_traces_1(:,3*i-1);
                molecules(i).Cy7_1            = accepted_traces_1(:,3*i);
                molecules(i).FRET_1           = FRET_traces_1(:,i);
                if raw_accept
                    molecules(i).accept_raw = accepted_raw_acceptor(:,i);
                end
                if raw_donor
                    molecules(i).donor_raw = accepted_raw_donor(:,i);
                end
                if leak
                    molecules(i).leakage_corr = leakage;
                end
%                 molecules(i).click_frames = click_frames_1(i,:);
                molecules(i).Cy3_2            = accepted_traces_2(:,3*i-2);
                molecules(i).Cy5_2            = accepted_traces_2(:,3*i-1);
                molecules(i).Cy7_2            = accepted_traces_2(:,3*i);
                molecules(i).FRET_2           = FRET_traces_2(:,i);
                if raw_accept
                    molecules(i).accept_raw = accepted_raw_acceptor(:,i);
                end
                if raw_donor
                    molecules(i).donor_raw = accepted_raw_donor(:,i);
                end
                if leak
                    molecules(i).leakage_corr = leakage;
                end
%                 molecules(i).click_frames_2 = click_frames_2(i,:);
            end
            
%             molecules_2 = repmat(struct(...   repmat will initialize each field in the structure array with the same value
%                 'extra_2',[],...       the processed extra value
%                 'donor_2',[],...       the processed donor value (usually normalized to bleached levels, but sometime nothing)
%                 'donor_raw_2',[],...   the raw, unprocessed donor signal
%                 'accept_corr_2',[],... the processed acceptor value, corrected for donor leakage and often then normalized to bleached level
%                 'accept_raw_2',[],...  the raw, unprocessed acceptor signal
%                 'FRET_2',[],...        the FRET traces are calculated from donor and accept_corr above
%                 'time_2',time_2,...
%                 'fr_rt',rate_fr,...
%                 'num_fr',n_fr,...
%                 'flow',flow,...
%                 'fretthresh',fretthreshold,...
%                 'leakage_corr',[],...
%                 'info',files{j},...
%                 'click_frames',[]),1,num_accep_traces_2);  %num_accep_traces defines the size of the structure array
            
%             for i = 1:num_accep_traces_2
%                 molecules_2(i).Cy3_2            = accepted_traces_2(:,3*i-2);
%                 molecules_2(i).Cy5_2            = accepted_traces_2(:,3*i-1);
%                 molecules_2(i).Cy7_2            = accepted_traces_2(:,3*i);
%                 molecules_2(i).FRET_2           = FRET_traces_2(:,i);
%                 if raw_accept
%                     molecules_2(i).accept_raw = accepted_raw_acceptor(:,i);
%                 end
%                 if raw_donor
%                     molecules_2(i).donor_raw = accepted_raw_donor(:,i);
%                 end
%                 if leak
%                     molecules_2(i).leakage_corr = leakage;
%                 end
%                 %molecules(i).click_frames = click_frames(i,:);
%             end
            
        %end
        %save(files{i},'molecules','-append');
        
        
        
        
        
        
        U_temp_1 = [U_temp_1 molecules];
%         U_temp_2 = [U_temp_2 molecules_2];
        clear molecules_1 molecules_2;
    end
    U = U_temp_1;
%     U_2 = U_temp_2;
    saveFilename = fileName(1:length(fileName)-4);
    disp(saveFilename);
    saveFilename = [path1 '\' saveFilename '_U.mat'];
    disp(saveFilename);
    %yy=[path1 '\saveFilename.mat'];
    save(saveFilename,'U')
%     yy=[path1 '\combined_struc_2.mat'];
%     save(yy,'U_2')
    
else
    disp('No files found');
end
