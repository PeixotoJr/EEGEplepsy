clear all; close all; clc; 
load  n1.dat
[Ch time]=size(n1);
chaneel=1:Ch;
wind=1:256;
figure (1)
surfc(wind/256,chaneel,n1(:,1001:1256));
xlabel('Tempo(s)'); ylabel('Canais');zlabel('EEG (mV)');

