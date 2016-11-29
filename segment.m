function [ seg ] = segment(x)
%SEG Summary of this function goes here
%   Detailed explanation goes here
    n = 200;
    r = [];
    for i = [n+1:n/2:max(size(x))]
        r = [r rms(x(1:i))];
    end
    
    p = prctile((r),[25 75]);
    IQ2 = p(2)-p(1);
    domain = [p(1)-1.5*IQ2 p(2)+1.5*IQ2];
    
    t = [n+1:n/2:max(size(x))];
    mask = ~excludedata((r), t ,'domain' , domain);
    r = r(mask);
    t = t(mask);
    %plot(t,r);
    
    mask = [false];
    r = smooth(smooth(r,'rlowess'));
    th = 0.0005;
    a = r;
    b = t;
    pp = [0];
    for i = [2 : max(size(a))]
        pp = [pp (a(i)-a(i-1))];
    end
    last = -1000;
    for i = [2 : max(size(a))]
        if (i > 2 & ( i < max(size(a)) - 3))
            mask = [mask (...
                ((pp(i)*pp(i-1)<0) & (pp(i+1)*pp(i)>0) & (pp(i+2)*pp(i+1)>0) ...
                 & (i-last >20))  | ...
            ((pp(i)*pp(i-1)>0)&(pp(i)-pp(i-1))> th & (i-last >20)))];
        else 
            mask = [mask false];
        end
        if mask(i)==true
            last = i;
        end
    end
    a = a(mask);
    b = b(mask);
    
    %{
    plot(t,r);
    hold on;
    scatter(b,a);
    plot(t,pp*10)
    for i = [1:max(size(a))]
        line([(b(i)) (b(i))],ylim)
    end
    hold off
    %}
    seg = b;
end

