% EXAMPLE Simple demo of the MFCC function usage.
%
%   This script is a step by step walk-through of computation of the
%   mel frequency cepstral coefficients (MFCCs) from a speech signal
%   using the MFCC routine.
%
%   See also MFCC, COMPARE.
%   Author: Kamil Wojcicki, September 2011
% Clean-up MATLAB's environment
 clear all; close all; clc;  
%Define variables
    Paciente='01';
    Arq_P1=['18';'03';'04';'15';'16';'18';'21';'26'];
    Arq_P2=['18';'03';'04';'15';'16';'18';'21';'27'];
    Tw = 2000;           % analysis frame duration (ms)
    Ts = 1000;           % analysis frame shift (ms)
    alpha = 1;           % preemphasis coefficient
    M = 30;              % number of filterbank channels 
    C = 5;               % number of cepstral coefficients
    L = 30;              % cepstral sine lifter parameter
    LF = 2;              % lower frequency limit (Hz)
    HF = 40;             % upper frequency limit (Hz)
 
   
%%

for j=1:length(Arquivo)  
 File=Arquivo(j,:);
 fprintf('*****Arquivo %s do Paciente %s******\n',File,Paciente);
  %Salinha 
  [header, data] = edfread(char(strcat({'/home/julio/Documentos/ftp/DataBase'},{'/chb'},{Paciente},{'_'},{File},'.edf')));
  %Em casa
  %[header, data] = edfread(char(strcat({'E:\BD\chb'},{Paciente},{'\chb'},{Paciente},{'_'},{File},'.edf')));
  [NCanais Amostras]=size(data);
  MELs.MFCCs=[];
  MELs.FBEs=[];
  MELs.frames=[];
  Features.All=[];
 % Read speech samples, sampling rate and precision from file
 %[ speech, fs, nbits ] = wavread( wav_file );
 fs=256;      
 Seg=Amostras/fs;
  
  %%
  for i=1:NCanais
speech=data(i,:);

    %[coeffs,delta,deltaDelta,loc] = mfcc(speech,fs); 

    % Feature extraction (feature vectors as columns)
    [ MELs.MFCCs{i}, MELs.FBEs{i}, frames] = ...
    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    if mod(Seg,2)==0
    MELs.MFCCs{i}(:,end+1)=MELs.MFCCs{i}(:,end);
    MELs.FBEs{i}(:,end+1)=MELs.FBEs{i}(:,end);
    end
    [lh cl]=size(MELs.MFCCs{i});
    Features.Channel{i}=reshape(MELs.MFCCs{i},[2*lh,floor(cl/2)]);
    Features.All=[Features.All; Features.Channel{i}];
          
    %Generate data needed for plotting 
    [ Nw, NF ] = size(frames);                % frame length and number of frames
    time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames 
    time = [0:length(speech)-1 ]/fs;           % time vector (s) for signal samples 
    logFBEs =20*log10( MELs.FBEs{i} );                 % compute log FBEs for plotting
    logFBEs_floor = max(logFBEs(:))-50;         % get logFBE floor 50 dB below max
    logFBEs(logFBEs<logFBEs_floor ) = logFBEs_floor; % limit logFBE dynamic range


    % Generate plots
    
    figure('Position', [30 30 800 600], 'PaperPositionMode', 'auto', ... 
              'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' ); 

    subplot( 311 );
    plot( time, speech, 'k' );
    xlim( [ min(time_frames)-1  max(time_frames)+1 ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Amplitude' ); 
    title( 'EEG -  waveform'); 

    subplot( 312 );
    imagesc( time_frames, [1:M], logFBEs ); 
    axis( 'xy' );
    xlim( [ min(time_frames)-1 max(time_frames)+1 ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Channel index' ); 
    title( 'Log (mel) filterbank energies'); 

    subplot( 313 );
    %imagesc( time_frames, [1:C], MFCCs(2:end,:) ); % HTK's TARGETKIND: MFCC
    imagesc( time_frames, [1:C+1], MELs.MFCCs{i});       % HTK's TARGETKIND: MFCC_0
    axis( 'xy' );
    xlim( [ min(time_frames) max(time_frames)+1 ] );
    xlabel( 'Time (s)' ); 
    ylabel( 'Cepstrum index' );
    title( 'Mel frequency cepstrum' );

    % Set color map to grayscale
    colormap( 1-colormap('hot') ); 
    % Print figure to pdf and png files
    print('-dpdf', sprintf('%s.pdf', mfilename)); 
    print('-dpng', sprintf('%s.png', mfilename)); 

  end
  %CHB01_MFCC{j}=Features.All;
  end
 % save CHB01_MFCC.mat CHB01_MFCC
  
  
  

    
    

