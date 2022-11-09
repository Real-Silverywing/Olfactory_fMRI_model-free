function [removed_tc,idx] = small_std_helper(data)
%help to remove small std time course
%   Detailed explanation goes here
stds = std(data,0,2);
idx = find(stds>=1);
removed_tc = data(stds>=1,:);
end

