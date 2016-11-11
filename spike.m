

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
v = v1;
Fs = 2000;
L = 40001;
w1 = 200;
w2 = 450;
v = fftbpf(v, Fs, L , w1, w2);
clf;

fftfig(v, Fs, L);
plot(t,v);
