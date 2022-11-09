function [removed_tc,idx] = small_std_helper(data, std_thres)
%help to remove the timecourses with small std(nearly constant)
% defalut threshold is 0.5
if nargin==1
    std_thres = 0.5;
    stds = std(data,0,2);
    idx = find(stds>=std_thres);
    removed_tc = data(stds>=std_thres,:);
elseif nargin==2
    stds = std(data,0,2);
    idx = find(stds>=std_thres);
    removed_tc = data(stds>=std_thres,:);

end

