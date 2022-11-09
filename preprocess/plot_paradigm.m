function [outputArg1,outputArg2] = plot_paradigm()
%PLOT_PARADIAM Summary of this function goes here
%   Detailed explanation goes here
figure()
rectangle('Position',[31-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)

rectangle('Position',[121-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
rectangle('Position',[211-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)  %'EdgeColor','blue',

  ylim([-1 1])
yticks([-1,0,1])
%yticklabels({'-1','0','1','2'}) %posi
yticklabels({'-1','0','1'})  %neg


hold on;
line([1,276],[0,0],'LineWidth',1.5,'Color','black')
line([7,36],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
line([97,126],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
line([187,216],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
end

