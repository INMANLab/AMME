function IsChannelEmpty(X,Fs)
    
    X = datRes;
    t = (0:(size(X,1)-1))/Fs;
    FsRes = 60;
    X = resample(X, t ,FsRes);
    XN = filloutliers(X,"clip","median");
    XN = normalize(XN,1,"zscore");
    XN(isnan(XN))=0;

    [p,f] = pspectrum(XN,FsRes,FrequencyLimits = [1,30]);
    pLow = sum(p(f<5,:));
    plot(pLow)
    hold on
    plot(sum(p))
    Cs = 1:149;
    xline(Cs(chIdx),'--k')

    plot(pLow./sum(p))  % this is working! Needs tweaking
    hold on
    Cs = 1:149;
    xline(Cs(chIdx),'--k')
    hold off


    plot(f,p)
    % ----------- Method 1: Using histogram of the derivative of the signal
    d1X = diff(X,1,1);
    % -- find frequency of zeros in the second derivative
    d1X = rmoutliers(d1X,1);
    % d1X1 = rescale(d1X,-1*ones(1,size(d1X,2)),ones(1,size(d1X,2),1)); %rescale values to compensate for truncation errors
    d1X = normalize(d1X,1,"range",[0,1]); %rescale values to compensate for truncation errors

    plot(d1X(:,148))
    hold on
    plot(XN(:,120))
    hold off

    nZeros = sum(d1X,1)/size(d1X,1); % Percent of zeros per channel
    A = histcounts(d1X(:,149),100,'Normalization','probability');
    plot(d1X(:,149))
    plot(A)
    K = kde(d1X(:,130));
    

    % Method 2: Using power bandwidth
    [bw,flo,fhi,~] = powerbw(XN,FsRes);
    bw(isnan(bw)) =0;
    plot(bw)


    % temporary tests
    f = 1/4;
    fs = 2;
    N = 128;2^12;
    t = (0:(N-1))/fs;
    % N = length(t);
    y = 2*sin(2*pi*f*t)+2*sin(2*pi*2*f*t);
    % y = exp(1j*2*pi*f*t)+exp(1j*2*pi*2*f*t);
    subplot 131 
    plot(t,real(y))
    subplot 132
    pwelch(y,[],[],[],fs)
    subplot 133
    fxx = ((0:N-1)*fs/N);
    % fxx = fs/length(y)*(-N/2:N/2-1);
    stem(fxx,abs(fft(y)/N).^2)
    % powerbw(y,fs)

    N = 1028;
    fs = 1;
    f = 1/4;
    x = exp(1j*2*pi*f*(0:N-1)/fs).';
    
    [p,f] = pspectrum(x,fs);

    % figure
    plot(f,p)
    hold on
    fxx = ((0:N-1)*fs/N); (0:2/N:2-1/N)*.5;
    stem(fxx,abs(fft(x)/N).^2)
    hold off
    axis([0 0.5 0 1.1])
    legend("pspectrum", "fft")
    grid
end