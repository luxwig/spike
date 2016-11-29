function [p, sigr] = fftbpf(sig, Fs, L, w1, w2)
    fv = fft(sig);
    ffilt = zeros(L,1);
    for i = [floor(w1*L/Fs)+1:floor(w2*L/Fs)+1]
        ffilt(i) = 1;
    end

    for i = [L-floor(w2*L/Fs)+1:L-floor(w1*L/Fs)+1]
        ffilt(i) = 1;
    end

    v = ifft(fv.*ffilt);
    sigr = v;
    p = ifft(fv.*(1-ffilt));
end