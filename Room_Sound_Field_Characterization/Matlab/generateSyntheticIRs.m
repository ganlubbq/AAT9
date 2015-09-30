function Speakerarray = GenerateSyntheticIRs(x,y,a,phi,fs,c)
%%This function takes the coordinates of each speaker and creates IRs based
%%on this. 
%Inputs: X coordinate, Y coordinate, distance from center mic to other mics,
%the tilt angle of the speaker, sampling frequency, speed of sound
%Outputs: IRs for each speaker/microphone combination
%NOTE: (0,0) is the center of the setup

%Christian Jøns, AAT9.


%Create simulatedIRs array
Speakerarray = [TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker() TSpeaker()];

%Allocating vectors
for k = 1:length(x)
    intermediatedistspkmic1(k,:)  = zeros(1,length(x));
    intermediatedistspkmic2(k,:)  = zeros(1,length(x));
    intermediatedistspkmic3(k,:)  = zeros(1,length(x));
end

%Calculate distances between speakers (Center microphone)

for k = 1:length(x)
for i = 1:length(x) 
    intermediatedistspkmic2(k,i) = sqrt(((x(k)-x(i))^2+(y(k)-y(i))^2));
end
end

distmatrixmic2 = intermediatedistspkmic2;

%Calculate the IR based on distmatrixmic2

%convert to time
timematrixmic2 = distmatrixmic2 ./c;

%convert to samples
samplesmatrixmic2 = round(timematrixmic2 .*fs);

%% Calculate coordinates for mic 1 and 3 after rotation with origo at each
%speaker
for i = 1:length(x)
    mic1Xmove(i) = a*cos(-phi(i)*pi/180);
    mic1Ymove(i) = -a*sin(-phi(i)*pi/180);
    mic3Xmove(i) = a*cos(-phi(i)*pi/180);
    mic3Ymove(i) = -a*sin(-phi(i)*pi/180);
end

%Add it to existing coordinates
for i = 1:length(x)
    mic1Xcoord(i) = x(i) + mic1Xmove(i);
    mic1Ycoord(i) = y(i) + mic1Ymove(i);
    mic3Xcoord(i) = x(i) + mic3Xmove(i);
    mic3Ycoord(i) = y(i) + mic3Ymove(i);
end

%Calculate distances between speakers (Microphone 1 and 3)
for k = 1:length(x)
for i = 1:length(x) 
    intermediatedistspkmic1(k,i) = sqrt(((mic1Xcoord(k)-x(i))^2+(mic1Ycoord(k)-y(i))^2));
    intermediatedistspkmic3(k,i) = sqrt(((mic3Xcoord(k)-x(i))^2+(mic3Ycoord(k)-y(i))^2));
end
end

distmatrixmic1 = intermediatedistspkmic1;
distmatrixmic3 = intermediatedistspkmic3;
% distmatrixmic1
% distmatrixmic2
% distmatrixmic3
%Calculate the IR based on distmatrix

%convert to time
timematrixmic1 = distmatrixmic1 ./c;
timematrixmic3 = distmatrixmic3 ./c;

%convert to samples
samplesmatrixmic1 = round(timematrixmic1 .*fs);
samplesmatrixmic3 = round(timematrixmic3 .*fs);


%% Convert samples to IRs and assign them to speaker object along with delay

%For speaker 1
if length(x)>=1
for i=1:length(x)
Speakerarray(1).id = 1;
Speakerarray(1).microphones(1).id = 1;
Speakerarray(1).microphones(2).id = 2;
Speakerarray(1).microphones(3).id = 3;
%mic1
Speakerarray(1).microphones(1).recordings(i).computedIR = [zeros(1,samplesmatrixmic1(1,i)) 1];
Speakerarray(1).microphones(1).recordings(i).fromSpeaker = i;
Speakerarray(1).microphones(1).recordings(i).estimatedTime = estimateDelay(Speakerarray(1).microphones(1).recordings(i).computedIR, fs);
%mic2
Speakerarray(1).microphones(2).recordings(i).computedIR = [zeros(1,samplesmatrixmic2(1,i)) 1];
Speakerarray(1).microphones(2).recordings(i).fromSpeaker = i;
Speakerarray(1).microphones(2).recordings(i).estimatedTime = estimateDelay(Speakerarray(1).microphones(2).recordings(i).computedIR, fs);
%mic3
Speakerarray(1).microphones(3).recordings(i).computedIR = [zeros(1,samplesmatrixmic3(1,i)) 1];
Speakerarray(1).microphones(3).recordings(i).fromSpeaker = i;
Speakerarray(1).microphones(3).recordings(i).estimatedTime = estimateDelay(Speakerarray(1).microphones(3).recordings(i).computedIR, fs);

Speakerarray(1).microphones(2).recordings(1).computedIR = [1];
end
end

%For speaker 2
if length(x)>=2
for i=1:length(x)
Speakerarray(2).id = 2;
Speakerarray(2).microphones(1).id = 1;
Speakerarray(2).microphones(2).id = 2;
Speakerarray(2).microphones(3).id = 3;
%mic1
Speakerarray(2).microphones(1).recordings(i).computedIR = [zeros(1,samplesmatrixmic1(2,i)) 1];
Speakerarray(2).microphones(1).recordings(i).fromSpeaker = i;
Speakerarray(2).microphones(1).recordings(i).estimatedTime = estimateDelay(Speakerarray(2).microphones(1).recordings(i).computedIR, fs);
%mic2
Speakerarray(2).microphones(2).recordings(i).computedIR = [zeros(1,samplesmatrixmic2(2,i)) 1];
Speakerarray(2).microphones(2).recordings(i).fromSpeaker = i;
Speakerarray(2).microphones(2).recordings(i).estimatedTime = estimateDelay(Speakerarray(2).microphones(2).recordings(i).computedIR, fs);
%mic3
Speakerarray(2).microphones(3).recordings(i).computedIR = [zeros(1,samplesmatrixmic3(2,i)) 1];
Speakerarray(2).microphones(3).recordings(i).fromSpeaker = i;
Speakerarray(2).microphones(3).recordings(i).estimatedTime = estimateDelay(Speakerarray(2).microphones(3).recordings(i).computedIR, fs);
Speakerarray(2).microphones(2).recordings(2).computedIR = [1];
end
end

%For speaker 3
if length(x) >=3
for i=1:length(x)
Speakerarray(3).id = 3;
Speakerarray(3).microphones(1).id = 1;
Speakerarray(3).microphones(2).id = 2;
Speakerarray(3).microphones(3).id = 3;
%mic1
Speakerarray(3).microphones(1).recordings(i).computedIR = [zeros(1,samplesmatrixmic1(3,i)) 1];
Speakerarray(3).microphones(1).recordings(i).fromSpeaker = i;
Speakerarray(3).microphones(1).recordings(i).estimatedTime = estimateDelay(Speakerarray(3).microphones(1).recordings(i).computedIR, fs);
%mic2
Speakerarray(3).microphones(2).recordings(i).computedIR = [zeros(1,samplesmatrixmic2(3,i)) 1];
Speakerarray(3).microphones(2).recordings(i).fromSpeaker = i;
Speakerarray(3).microphones(2).recordings(i).estimatedTime = estimateDelay(Speakerarray(3).microphones(2).recordings(i).computedIR, fs);
%mic3
Speakerarray(3).microphones(3).recordings(i).computedIR = [zeros(1,samplesmatrixmic3(3,i)) 1];
Speakerarray(3).microphones(3).recordings(i).fromSpeaker = i;
Speakerarray(3).microphones(3).recordings(i).estimatedTime = estimateDelay(Speakerarray(3).microphones(3).recordings(i).computedIR, fs);
Speakerarray(3).microphones(2).recordings(3).computedIR = [1];
end
end

%For speaker 4
if length(x) >= 4
for i=1:length(x)
Speakerarray(4).id = 4;
Speakerarray(4).microphones(1).id = 1;
Speakerarray(4).microphones(2).id = 2;
Speakerarray(4).microphones(3).id = 3;
%mic1
Speakerarray(4).microphones(1).recordings(i).computedIR = [zeros(1,samplesmatrixmic1(4,i)) 1];
Speakerarray(4).microphones(1).recordings(i).fromSpeaker = i;
Speakerarray(4).microphones(1).recordings(i).estimatedTime = estimateDelay(Speakerarray(4).microphones(1).recordings(i).computedIR, fs);
%mic2
Speakerarray(4).microphones(2).recordings(i).computedIR = [zeros(1,samplesmatrixmic2(4,i)) 1];
Speakerarray(4).microphones(2).recordings(i).fromSpeaker = i;
Speakerarray(4).microphones(2).recordings(i).estimatedTime = estimateDelay(Speakerarray(4).microphones(2).recordings(i).computedIR, fs);
%mic3
Speakerarray(4).microphones(3).recordings(i).computedIR = [zeros(1,samplesmatrixmic3(4,i)) 1];
Speakerarray(4).microphones(3).recordings(i).fromSpeaker = i;
Speakerarray(4).microphones(3).recordings(i).estimatedTime = estimateDelay(Speakerarray(4).microphones(3).recordings(i).computedIR, fs);
Speakerarray(4).microphones(2).recordings(4).computedIR = [1];
end
end

%For speaker 5
if length(x)>=5
for i=1:length(x)
Speakerarray(5).id = 5;
Speakerarray(5).microphones(1).id = 1;
Speakerarray(5).microphones(2).id = 2;
Speakerarray(5).microphones(3).id = 3;
%mic1
Speakerarray(5).microphones(1).recordings(i).computedIR = [zeros(1,samplesmatrixmic1(5,i)) 1];
Speakerarray(5).microphones(1).recordings(i).fromSpeaker = i;
Speakerarray(5).microphones(1).recordings(i).estimatedTime = estimateDelay(Speakerarray(5).microphones(1).recordings(i).computedIR, fs);
%mic2
Speakerarray(5).microphones(2).recordings(i).computedIR = [zeros(1,samplesmatrixmic2(5,i)) 1];
Speakerarray(5).microphones(2).recordings(i).fromSpeaker = i;
Speakerarray(5).microphones(2).recordings(i).estimatedTime = estimateDelay(Speakerarray(5).microphones(2).recordings(i).computedIR, fs);
%mic3
Speakerarray(5).microphones(3).recordings(i).computedIR = [zeros(1,samplesmatrixmic3(5,i)) 1];
Speakerarray(5).microphones(3).recordings(i).fromSpeaker = i;
Speakerarray(5).microphones(3).recordings(i).estimatedTime = estimateDelay(Speakerarray(5).microphones(3).recordings(i).computedIR, fs);
Speakerarray(5).microphones(2).recordings(5).computedIR = [1];
end
end
    

end
