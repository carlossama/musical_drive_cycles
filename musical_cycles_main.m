close all; clear all;
%% General Parameters

Fs = 20000;                % sound sample frequency 
number_of_notes = 15;      %
norm_correlation = 0.999;   % percentage of correlation between signal and transform
component_limit = 4;       % enforce a limit on the number of frequnecy components

%% Load Data

% make sure the files are in the active directory
load piano.mat
[num, txt, raw] = xlsread('US06.xlsx');

%% Main Cosine Transform Processing

% build a larger signal
spd = num(:,2);
time = num(:,1);
time2 = linspace(0,time(end),6000);
spd = interp1(time,spd,time2, 'spline');
time = time2;

% split the signal into sections for the number of notes
num_sections = number_of_notes;
section_size = ceil(length(spd) / num_sections);
section_idxs = 1:section_size:length(spd);
all_notes = zeros(num_sections,10000);
if section_idxs(end) ~= length(spd)
    section_idxs = [section_idxs, length(spd)];
end

% iterate through the sections taking the dct of each section, filter out 
% frequency components with small contributions, correlate frequencies with 
% notes in the A440 musical range, take the inverse cosine transform of 
% the frequency components to rebuild the signal
results = [];
disp('---------------------------------------------')
disp('  Notes/Chords of the cycle :   ')
disp('')
for parts = 1:length(section_idxs)-1
    s = spd(section_idxs(parts):section_idxs(parts+1));
    Y = discreteCosineXfer(s);
    Y = normFilter(Y, component_limit, norm_correlation);
    freqs = abs(Y(Y ~= 0));
    sf = inverseCosineXfer(Y,s');
    results = [results, sf'];
    to_disp = '';
    for k = 1:length(freqs)
        [val, idx] = min(abs(freqs(k) - piano_freq));
        freqs(k) = piano_freq(idx);
        to_disp = [to_disp, ' ' , piano_notes{idx}];
    end
    disp(to_disp)
    notes = [];
    for k = 1:length(freqs)
        notes = [notes; linspace(0,round(freqs(k)) * pi, 10000)];
        notes(k,:) = sin(notes(k,:)); 
    end
    notes = sum(notes, 1);
    all_notes(parts,:) = notes;
end


%% Plotting and sound 

a = figure(1);
for i = 1:size(all_notes, 1)
    
    plot(time, spd)
    hold on
    plot(time(section_idxs(i):section_idxs(i+1)),results(section_idxs(i):section_idxs(i+1)));
    hold off
    sound(all_notes(i,:),Fs)
    pause(0.5);
    
end
