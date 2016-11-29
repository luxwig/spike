

%% Load data
v1 = csvread('data//data.csv');
v2 = v1(:,2);
v1 = v1(:,1);
t = [0:1/2000:20];
subplot(2,1,1);
plot(t,v1);
subplot(2,1,2);
plot(t,v2);

%% Filter
v = v2;
Fs = 2000;
L = 40001;
w1 = 20;
w2 = 350;
[vr v] = fftbpf(v, Fs, L , w1, w2);

seg = segment(v);
seg = [0 seg numel(v)];


%{
plot(t,v);

hold on
for i = [2:max(size(seg))]
        plot([t(seg(i)) t(seg(i))],ylim)
end
hold off
%}
center = [];
level = 4;
for i = [2:numel(seg)]
    cv = v(seg(i-1)+1:seg(i));
    ct = t(seg(i-1)+1:seg(i));
    %plot(cv)
    %hold on
    [a,b]=wavedec(cv,5,'Haar');
    D=detcoef(a,b,level);
    %{
    sign = [-.1];
    for i = [2:numel(D)]
        if D(i)*D(i-1) < 0
            sign = [sign sign(end)*(-1)];
        else
            sign = [sign sign(end)];
        end
    end
    %}
    sign = [1];
    for j = [2:numel(D)]
        if D(j)>0 && D(j-1)< 0
            sign = [sign j];
        end
    end
    
    centerp = [];
    for j = [2:numel(sign)]
        s = cv(sign(j-1)*2^level:min(sign(j)*2^level,numel(cv)));
        [maxv,maxp] = max(abs(s));
        maxp = maxp + sign(j-1)*2^level - 1;
        centerp = [centerp maxp];
        %{
        plot(v);
        hold on
        plot([max(1,maxp-16):min(maxp+16,numel(v))],s,'r')
        hold off
        xlim([max(1,maxp-16)*0.8 min(maxp+16,numel(v))*1.2])
        pause;
        %}
    end
    centerp = recenterwv(centerp,cv);
    center = [center centerp+seg(i-1)];
    %{
    for i = [1 : numel(center)]
        maxp = center(i);
        s = v(max(1,maxp-16):min(maxp+16,numel(v)));
        plot(v);
        hold on
        plot([max(1,maxp-16):min(maxp+16,numel(v))],s,'r')
        hold off
        xlim([max(1,maxp-16)*0.8 min(maxp+16,numel(v))*1.2])
        pause;
    end
    scatter(sign*2^4,zeros(size(sign)),'r');
    median(abs(D));
    hold off
    pause
    %}
end

center = recenterwv(center, v);
figure
hold on
for i = [1 : numel(center)]
    maxp = center(i);
    s = v(max(1,maxp-16):min(maxp+16,numel(v)));
    plot(s);
end
hold off
