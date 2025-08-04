function patient = ReadLogFiles(patient,p,WD)

cd(WD+string(patient(p).name))
switch patient(p).exp
    case 'Original'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read in information about STUDY SESSION from log file %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        logfn = patient(p).phase(1).logFile;
        fileID = fopen(logfn);
        C = textscan(fileID,'%d %f %s %d %s %*[^\n]', 'HeaderLines',3);
        fclose(fileID);
        if(length(C{1})~=160)
            fprintf('Error: there should be 160 trials in study session.  Check %s.\n', logfn);
        end

        T = table;
        varNames = ["number","rt","in_or_out","stimulation","full_im_name"];
        for vIdx = 1:length(varNames)
            T.(varNames(vIdx)) = C{vIdx};
        end
        trialTimes = reshape(patient(p).phase(1).trial_start_times,[],1);
        if(length(trialTimes)==size(T,1))
            T.start_time = trialTimes;
        else
            T.start_time = nan(size(T,1),1);
        end
        T.stimType = repmat("stim",size(T,1),1);
        T.stimType(T.stimulation==0) = "nostim";
        patient(p).phase(1).trial = T;
        
        %FYI
        %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
        %C{2}(1:5) should be RTs for first 5 trials
        %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
        %C{4}(1:5) should be 1 (stim) or 0 (no stim) for first five trials
        %C{5}{1} should be name of image file for first trial

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read in information about ONE DAY TEST  from 2nd log file %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        logfn = patient(p).phase(3).logFile;
        fileID = fopen(logfn);

        C = textscan(fileID,'%d %f %s %s %s %s %*[^\n]', 'HeaderLines',3);%skip 3 header rows
        fclose(fileID);
        if(length(C{1})~=120)
            fprintf('Error: there should be 120 trials in one-day test session.  Check %s.\n', logfn);
        end

        T = table;
        varNames = ["number","rt","yes_or_no","sure_notsure","trial_type","full_im_name"];
        for vIdx = 1:length(varNames)
            T.(varNames(vIdx)) = C{vIdx};
        end
        trialTimes = reshape(patient(p).phase(3).trial_start_times,[],1);
        if(length(trialTimes)==size(T,1))
            T.start_time = trialTimes;
        else
            T.start_time = nan(size(T,1),1);
        end
        patient(p).phase(3).trial = T;
        T = outerjoin(patient(p).phase(1).trial, patient(p).phase(3).trial,...
                       "Keys","full_im_name","Type","left",...
                       "LeftVariables","number",...
                       "RightVariables",["number","rt","yes_or_no","sure_notsure","trial_type"]);
        T.Properties.VariableNames = "test_"+convertCharsToStrings(T.Properties.VariableNames);
        T.Properties.VariableNames(1) = "number";
        T.Properties.VariableNames(2) = "whichtest";
        T = join(patient(p).phase(1).trial, T,...
                       "Keys","number");
        patient(p).phase(1).trial = T;
        
        sanityCheck = strcmp(T.stimType,T.test_trial_type);
        sanityCheck = sanityCheck(T.whichtest>0);
        if(sum(sanityCheck)~=length(sanityCheck))
            fprintf('Error: wrong trial type found in patient %s', patient(p).name);
        end
        %FYI
        %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
        %C{2}(1:5) should be RTs for first 5 trials
        %C{3}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
        %C{4}{1} should be 'sure' or 'notsure'
        %C{5}{1} should be 'stim', 'nostim', or 'new'
        %C{6}{1} should be name of image file for first trial

    case 'Duration'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read in information about STUDY SESSION from log file %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        logfn = patient(p).phase(1).logFile;
        fileID = fopen(logfn);
        C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3);
        fclose(fileID);
        if(length(C{1})~=240)
            fprintf('Error: there should be 240 trials in study session.  Check %s.\n', logfn);
        end
        
        T = table;
        varNames = ["number","rt","in_or_out","stimulation","full_im_name","amp","sycnfromstart","getsecs"];
        for vIdx = 1:length(varNames)
            T.(varNames(vIdx)) = C{vIdx};
        end
        trialTimes = reshape(patient(p).phase(1).trial_start_times,[],1);
        if(length(trialTimes)==size(T,1))
            T.start_time = trialTimes;
        else
            T.start_time = nan(size(T,1),1);
        end
        T.stimType = repmat("nostim",size(T,1),1);
        T.stimType(T.stimulation~=0) = T.stimulation(T.stimulation~=0)+"s stim";
        patient(p).phase(1).trial = T;

        %FYI
        %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
        %C{2}(1:5) should be RTs
        %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
        %C{4}(1:5) should be 1 (1 sec stim), 3 (3 sec stim), or 0 (no stim)
        %C{5}{1} should be name of image file
        %C{6}{1} - amplitude of stimulation in microamps
        %C{7}{1} - sync from starting time in seconds
        %C{8}{1} - GetSecs computer clock


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read in information about ONE DAY TEST  from 2nd log file %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        logfn = patient(p).phase(3).logFile;
        fileID = fopen(logfn);
        C = textscan(fileID,'%d %f %f %s %s %s %s %s %s %s %s %*[^\n]', 'HeaderLines',3,'Delimiter','\t');%skip 3 header rows
        fclose(fileID);
        if(length(C{1})~=200)
            fprintf('Error: there should be 200 trials in one-day test session.  Check %s.\n', logfn);
        end

        T = table;
        varNames = ["number","rt","confrt","yes_or_no","sure_notsure","trial_type","full_im_name","sycnfromstart","getsecs","yesno_time","surenotsure_time"];
        for vIdx = 1:length(varNames)
            T.(varNames(vIdx)) = C{vIdx};
        end
        trialTimes = reshape(patient(p).phase(3).trial_start_times,[],1);
        if(length(trialTimes)==size(T,1))
            T.start_time = trialTimes;
        else
            T.start_time = nan(size(T,1),1);
        end
        patient(p).phase(3).trial = T;
        T = outerjoin(patient(p).phase(1).trial, patient(p).phase(3).trial,...
                       "Keys","full_im_name","Type","left",...
                       "LeftVariables","number",...
                       "RightVariables",["number","rt","yes_or_no","sure_notsure","trial_type"]);
        T.Properties.VariableNames = "test_"+convertCharsToStrings(T.Properties.VariableNames);
        T.Properties.VariableNames(1) = "number";
        T.Properties.VariableNames(2) = "whichtest";
        T = join(patient(p).phase(1).trial, T,...
                       "Keys","number");
        patient(p).phase(1).trial = T;
        
        sanityCheck = strcmp(T.stimType,T.test_trial_type);
        sanityCheck = sanityCheck(T.whichtest>0);
        if(sum(sanityCheck)~=length(sanityCheck))
            fprintf('Error: wrong trial type found in patient %s', patient(p).name);
        end
        %FYI
        %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
        %C{2}(1:5) should be RTs
        %C{3}{1} should be confidence RTs
        %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
        %C{5}{1} should be 'sure' or 'notsure'
        %C{6}{1} should be condition of '1s stim', '3s stim', 'nostim', or 'new'
        %C{7}{1} should be name of image file for first trial
        %C{8}{1} -sync from starting time in seconds
        %C{9}{1} - GetSecs computer clock
        %C{10}{1} - YesNo Time on computer clock
        %C{11}{1} - Sure NotSure Time on computer clock

    case 'Timing'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read in information about STUDY SESSION from log file %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        logfn = patient(p).phase(1).logFile;
        fileID = fopen(logfn);
        C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3); % reads in 3 header lines
        %means skip to the next line(row) --> %*[^\n]
        fclose(fileID);
        if(length(C{1})~=200)
            fprintf('Error: there should be 200 trials in study session.  Check %s.\n', logfn); %fprintf displays in command window
        end

        T = table;
        varNames = ["number","rt","in_or_out","stimulation","full_im_name","amp","sycnfromstart","getsecs"];
        for vIdx = 1:length(varNames)
            T.(varNames(vIdx)) = C{vIdx};
        end
        trialTimes = reshape(patient(p).phase(1).trial_start_times,[],1);
        if(length(trialTimes)==size(T,1))
            T.start_time = trialTimes;
        else
            T.start_time = nan(size(T,1),1);
        end
        T.stimType = repmat("nostim",size(T,1),1);
        T.stimType(T.stimulation==1) = "Before stim";
        T.stimType(T.stimulation==2) = "During stim";
        T.stimType(T.stimulation==3) = "After stim";
        patient(p).phase(1).trial = T;
        
        %FYI for C = textscan above
        %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers %d is for double as whole number
        %C{2}(1:5) should be RTs for first 5 trials %f is float w a decimal
        %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
        %C{4}(1:5) should be 0, 1, 2, 3 (no stim, before, during, after)
        %C{5}{1} should be name of image file for first trial
        %C{6}{1} - amplitude of stimulation in microamps
        %C{7}{1} - sync from starting time in seconds
        %C{8}{1} - GetSecs computer clock

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read in information about ONE DAY TEST  from 2nd log file %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        logfn = patient(p).phase(3).logFile;
        fileID = fopen(logfn);
        C = textscan(fileID,'%d %f %s %s %s %s %s %s %s %s %s %*[^\n]', 'HeaderLines',3,'Delimiter','\t');%skip 3 header rows
        %go to a new line --> %*[^\n] has to be at the end of the textscan format
        fclose(fileID);
        if(length(C{1})~=300)
            fprintf('Error: there should be 300 trials in one-day test session.  Check %s.\n', logfn);
        end

        T = table;
        varNames = ["number","rt","confrt","yes_or_no","sure_notsure","trial_type","full_im_name","sycnfromstart","getsecs","yesno_time","sure_notsure_time"];

        for vIdx = 1:length(varNames)
            T.(varNames(vIdx)) = C{vIdx};
        end
        trialTimes = reshape(patient(p).phase(3).trial_start_times,[],1);
        if(length(trialTimes)==size(T,1))
            T.start_time = trialTimes;
        else
            T.start_time = nan(size(T,1),1);
        end
        patient(p).phase(3).trial = T;
        T = outerjoin(patient(p).phase(1).trial, patient(p).phase(3).trial,...
                       "Keys","full_im_name","Type","left",...
                       "LeftVariables","number",...
                       "RightVariables",["number","rt","yes_or_no","sure_notsure","trial_type"]);
        T.Properties.VariableNames = "test_"+convertCharsToStrings(T.Properties.VariableNames);
        T.Properties.VariableNames(1) = "number";
        T.Properties.VariableNames(2) = "whichtest";
        T = join(patient(p).phase(1).trial, T,...
                       "Keys","number");
        patient(p).phase(1).trial = T;
        
        sanityCheck = strcmp(T.stimType,T.test_trial_type);
        sanityCheck = sanityCheck(T.whichtest>0);
        if(sum(sanityCheck)~=length(sanityCheck))
            fprintf('Error: wrong trial type found in patient %s', patient(p).name);
        end

        %FYI
        %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
        %C{2}(1:5) should be RTs for first 5 trials
        %C{3}{1} should be confirmed RT
        %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
        %C{5}{1} should be 'sure' or 'notsure'
        %C{6}{1} should be 'Before', 'During', 'After', 'new'
        %C{7}{1} should be name of image file for first trial
        %C{8}{1} sync from start cumulative timing in seconds of sync pulses
        %C{9}{1} getsecs - computer's inner clock
        %C{10}{1} Yes/No trial cumulative timing in seconds from the start
        %C{11}{1} sure/notsure tria cumulative timing in seconds from the start

end
end






