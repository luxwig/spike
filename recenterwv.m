function [ result ] = recenterwv(c, s)
    result = [];
    upper = c(1)+16;
    lower = 1;
    for i = 1:numel(c)
        if c(i) > upper
                [maxv, maxp] = max(s(lower:upper));
                maxp = maxp + lower - 1;
                result = [result maxp];
            lower = max(0,c(i)-16);
        end
        upper = min(c(i)+16, numel(s));
    end
    [maxv, maxp] = max(s(lower:upper));
    maxp = maxp + lower - 1;
    result = [result maxp];
end

