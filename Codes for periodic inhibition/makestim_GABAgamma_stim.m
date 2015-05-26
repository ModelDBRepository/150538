function makestim_GABAgamma(poidur, stimdur, gammafreq, prespfreqs);

% make the conductance waveform of 'gamma GABA full stochastic' (the same as the classical one except for 'no synaptic delay' (see below))
%
% [condwaves, cumrandoms] = makestim_GABAgamma(poidur, stimdur, gammafreq, prespfreqs)
%
% <input variables>
%   poidur : duration of the preceding Poisson conductance ([sec])
%   stimdur : duration of the gamma GABA conductance ([sec])
%   gammafreq : frequency of the pressumed LFP gamma oscillation ([Hz])
%   prespfreqs : set of frequencies of the total presynaptic GABAergic (FS) spikes ([Hz])
%
% <output variables>
%   condwaves : conductance waveforms
%   cumrandoms : random numbers used (A{k_prespfreq}{1:randoms-for-cycle, 2:randoms-for-phase, 3:randoms-for-Poisson}) (NB: CUMLATIVELY including ALL the random numbers used)
%
% NB: '1 ms synaptic delay', which was included in all of the previous stimuli, is NO LONGER included here! (should be careful at the time of the analysis!!)
%
% e.g.,
%   [G,R] = makestim_GABAgamma(2, 5, 40, [600:20:1200]);
%
% Kenji Morita
% Sep 2007

% Modified from Kenji's codes by Min

for j=1:21 
    poidur=1; stimdur=11;  %unit-s
    prespfreqs=2000;     %event number
    gammafreq=2+4*(j-1);   %frequency of each synapse

% sampling rate used in Ginj
samplerate = 20000; % [Hz]
% poidur=0.5; stimdur=4;
% gammafreq=40; prespfreqs=[1000];
gammadur=stimdur-poidur;
% generate random numbers
prespfreqs_diff = [prespfreqs(1) diff(prespfreqs)];
tmp_cyclerandoms = [];
tmp_phaserandoms = [];
tmp_poirandoms = [];
for k = 1:length(prespfreqs_diff)
    % randoms for "which gamma cycle"
    randoms{k}{1} = rand(prespfreqs_diff(k)*gammadur,1);
    tmp_cyclerandoms = [tmp_cyclerandoms; randoms{k}{1}];
    cumrandoms{k}{1} = tmp_cyclerandoms;
    % randoms for "at which phase within a gamma cycle"
    randoms{k}{2} = rand(prespfreqs_diff(k)*gammadur,1);
    tmp_phaserandoms = [tmp_phaserandoms; randoms{k}{2}];
    cumrandoms{k}{2} = tmp_phaserandoms;
    % randoms for poisson
    randoms{k}{3} = rand(prespfreqs_diff(k)*poidur,1);
    tmp_poirandoms = [tmp_poirandoms; randoms{k}{3}];
    cumrandoms{k}{3} = tmp_poirandoms;
end

% conductance waveforms
% preparation for gamma

% load FS_inv_spline % load spline representation of the FS cumulative probability function, which was made by 'Mccum'
% spike_cum_function = FS_inv_spline;

delta2=5;
load GABAspline_Gaussian_delta2_5.mat  %change delta_2 in Mccum_Gaussian.m accordingly!!!

spike_cum_function = FS_inv_spline;

num_points_per_cycle = (1/gammafreq) * samplerate;

for k = 1:length(prespfreqs)
    % gamma
    indice_cycle = ceil(cumrandoms{k}{1} * (gammafreq*gammadur)); % which gamma cycle the relevant pre spike is belonging to
    cycle_start_points = (poidur + (indice_cycle - 1) * (1/gammafreq)) * samplerate; % - 10*0.001  points (wrt samplerate) of the gamma cycle including the relevant pre spike
    prespphases_per_cycle = ppval(spike_cum_function, cumrandoms{k}{2});
    presppoints_per_cycle = round(num_points_per_cycle * prespphases_per_cycle); % points (wrt samplerate) of the presynaptic spikes within a single gamma cycle
    presppoints = cycle_start_points + presppoints_per_cycle; % points (wrt samplerate) of the presynaptic spikes from the beginning
    for k_spgamma = 1:length(presppoints)
        tmp_gamma(k_spgamma) = round(presppoints(k_spgamma))/samplerate*1000;
    end
    % add the preceding Poisson conductance
    presppoints_Poisson = round(samplerate * poidur * cumrandoms{k}{3});
    for k_prespPoisson = 1:length(presppoints_Poisson)
        tmp_start(k_prespPoisson) = (presppoints_Poisson(k_prespPoisson) + 1)/samplerate*1000; % '+1' is just avoid to become 0
    end
    prespiketime_gamma = length(tmp_start)+length(tmp_gamma);
    prespiketime_gamma = [prespiketime_gamma; tmp_start'; tmp_gamma'];
    save(['GABAprespikes_delta2_' num2str(delta2) '_' num2str(gammafreq) '_' num2str(prespfreqs) '.dat'], 'prespiketime_gamma', '-ascii');
end

end
clear all;
