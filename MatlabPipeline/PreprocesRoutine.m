function dat = PreprocesRoutine(dat, parameters, step)%, chIdx)
% parameters.stepOrder should include steps in the desired order:
% Example: ["Resample","Rerefrence","Bandpass","Bandstop"]

if(~exist("step","var"))
    step = 1;
    disp("----------Preprocessing Pipeline:")
end
% if(~exist("channels","var"))
%     chIdx = 1:size(dat,2);
% end

%---- get the current Fs
Fs = parameters.Fs;

% channelPlot = 1;
% subplot 211
% hold on
% tPlot = (0:1/parameters.Fs:10);
% plot(tPlot, dat(1:length(tPlot),channelPlot)-mean(dat(1:length(tPlot),channelPlot)));
% subplot 212
% hold on
% pwelch(dat(:,channelPlot)-mean(dat(:,channelPlot)),[],[],[],parameters.Fs)
% xlim([0,120])



processIdentifier = parameters.preprocessStepOrder(step);
disp("Step"+ step+":" + processIdentifier)
switch processIdentifier
    case "Resample" %############################ Resample
        FsRes = parameters.Resample.FsRes;
        t = (0:(size(dat, 1) - 1))/Fs;
        dat = resample(dat, t, FsRes);
        
        parameters.Fs = FsRes;  % Update Fs with the resampling frequency

    case "Rerefrence" %############################ ReReference
        medVal = median(dat,2);
        dat = dat - medVal;

    case "Bandpass" %############################ Bandpass
        % "BandpassButterWorth"
        % %------------ Set the parameters 
        % lowCut = parameters.Bandpass.FcLow;
        % highCut = parameters.Bandpass.FcHigh;
        % nF = parameters.Bandpass.Order;
        % %------------- Create the filter
        % Wn = [lowCut, highCut]/(Fs/2);
        % [b, a] = butter(nF,Wn,"bandpass","ctf");
        % %------------- Apply the filter
        % dat = filtfilt(b,a, dat);

        % "BandpassRemezord"  Has linear phase and sharper amplitude response
        %------------ Set the parameters
        lowCut = parameters.Bandpass.FcLow;
        highCut = parameters.Bandpass.FcHigh;
        rS = parameters.Bandpass.rippleStop;
        rP = parameters.Bandpass.ripplePass;
        %------------- Create the filter
        % New Remezord Filter in Matlab is called from firpmord Func.
        % I changed the stop frequencies to .5 to not get close to zero or
        % Fs/2 Because:
        % Results are inaccurate if cutoff frequencies are near zero
        % frequency or the Nyquist frequency.
        [n,fo,mo,w] = firpmord([lowCut-.5 lowCut highCut highCut+.5], [0 1 0], [rS rP rS], Fs);
        % [n,fo,mo,w] = remezord([lowcut-1 lowcut highcut highcut+1], [0 1 0], [1 1 1]*0.01, Fs);
        b = firpm(n,fo,mo,w);
        a=1;
        %------------- Apply the filter
        dat = filtfilt(b,a, dat);

    case "Bandstop" %############################ Bandstop
        % Multitaper method from Chronux
        %---------------iteratively apply filters
        for idx = 1:length(parameters.BandStop.Fc)
            %------------ Set the parameters
            params.Fs = Fs;
            params.tapers = parameters.BandStop.tapers(idx,:);
            params.fpass = parameters.BandStop.Fpass(idx,:);
            params.pad = parameters.BandStop.pad(idx);
            params.err = parameters.BandStop.err(idx,:);
            params.trialave = parameters.BandStop.trialave(idx);

            Fc = parameters.BandStop.Fc(idx);
            pVal = parameters.BandStop.pVal(idx);
            tau = parameters.BandStop.tau(idx);
            movingwin = parameters.BandStop.movingwin(idx,:);
            %------------- Apply filter
            dat = rmlinesmovingwinc(dat, movingwin, tau, params, pVal,'n', Fc);%remove 60 Hz noise

        end
end
%------ Increase step and Call back the preprocess routine until all steps
% are applied
step = step+1;
if(step<=length(parameters.preprocessStepOrder))
    dat = PreprocesRoutine(dat, parameters, step);
end

end