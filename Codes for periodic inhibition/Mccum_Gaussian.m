  
function Mccum_Gaussian
global delta_2


    
delta_2=5;
% global amp
% amp=0.3;
% a code to make cumulative distribution functions for RS and FS based on
%%%%%%%%%% create cumulative distribution functions for RS and FS
%%%%%%%%%% %%%%%%%%%%
pp_cumulative_FS = Mccum_main(2,1/50);
FS_spline = pp_cumulative_FS; % re-naming
%%%%%%%%%% create spline representation of the inverse function of the cumulative distribution functions %%%%%%%%%%
tmpx = [0:0.001:1];
tmpyFS = ppval(FS_spline,tmpx);
FS_inv_spline = spline(tmpyFS,tmpx);
save(['GABAspline_Gaussian_delta2' '_' num2str(delta_2) '.mat'], 'FS_inv_spline');
% save(['GABAspline_Sin_amp' '_' num2str(amp) '.mat'], 'FS_inv_spline');
%%%%%%%%%% inner-file functions %%%%%%%%%%
%-----


function pp_cumulative = Mccum_main(RSorFS,filtersigma)
global delta_2
% global amp
sampleinterval = 0.001;
x = [0:sampleinterval:1];
% plot to check
if 1
   
%     y = GABA_density(0,delta_2,x);
% %     y = GABA_density_sin(amp,x);
%     F_density = figure;
%     A_density = axes;
%     hold on;
%     tmp = plot([0:sampleinterval:2],[y(1:end-1) y],'k'); set(tmp,'LineWidth',1); % after filtering and spline
% %     axis([0 2 0 0.9]);
%     set(A_density,'Box','on');
%     set(A_density,'XTick',[0:0.5:2]);
%     set(A_density,'YTick',[0:0.2:0.9]);
end

%%% making cumulative distribution function by integrating the above probability density

% numerical integration
tmp = zeros(1,length(x));
for j = 1:length(x)
    fprintf('I''m now numerically integrating at %d\n',j);
    tmp(j) = quad(@evalspline, 0, x(j), 1.0e-8); % numerically integrate 'evalspline' with the 2nd input variable 'pp_density_wonorm' (NB: 'pp_density_wonorm' should be 6th input of 'quad')
end
y_cumulative = tmp / tmp(end); % division by 'tmp(end)' is for normalization to have a value 1 at the end.
% NB: The above 'y_cumulative' on the below 'x' is a final fitting (but before spline) of the cumulative distribution
pp_cumulative = spline(x,y_cumulative); % make a spline approximation of the density function 'y_cumulative on x'
% so now the function 'ppval(pp_cumulative,x)', or equivalently, 'evalspline(x,pp_cumulative)' gives the ultimately final splined version of the cumulative distribution function

% plot to check
if 1
%     z = ppval(pp_cumulative,x);
%     F_cumulative = figure;
%     A_cumulative = axes;
%     hold on;
%     tmp = plot([0:sampleinterval:2],[z(1:end-1) 1+z],'k'); set(tmp,'LineWidth',1); % plot repeats to check the smoothness of the connection
% %     axis([0 2 0 2]);
%     set(A_cumulative,'Box','on');
% %     set(A_cumulative,'XTick',[0:0.5:2]);
% %     set(A_cumulative,'YTick',[0:0.5:2]);
end
%-----


function y = evalspline(x)
global delta_2
% global amp
y = GABA_density(0,delta_2,x);
% y = GABA_density_sin(amp,x);
