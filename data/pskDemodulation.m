%------------------------------------------------------------------------------------------------------------
%                  Introduction to the input and output parameters of the function                          |
%   <SymData>           --- (Datatype = Real number)                                                        |
%                           (intrduction = Coherent demodulation of the input modulated signal.)            |
%   <SymNum>            --- (Datatype = Real number)                                                        |
%                           (intrduction = Baseband data length.)                                           |
%   <fs>                --- (Datatype = Real number)                                                        |
%                           (intrduction = Specifies the sampling frequency of the ADC, the unit is Hz.)    |
%   <Band>              --- (Datatype = Real number)                                                        |
%                           (intrduction = Specifies the symbol rate.)                                      |
%   <CarrFre>           --- (Datatype = Real number)                                                        |
%                           (intrduction = Specifies the carrier frequency , the unit is Hz)                |
%   <ModSignal>         --- (Datatype = Real number)                                                        |
%                           (intrduction = Demodulated baseband signal.)                                    |
%                                                                                                           |
%                                       Function introduction                                               |
%   This function demodulates BPSK.                                                                         |
%                                                                                                           |
%                                              NOTE                                                         |
%                                                                                                           |
%   When the demodulated data is -1, it means invalid data.                                                 |
%                                                                                                           |
%                                      Bit error rate test code                                             |
% Example:                                                                                                  |
%                                                                                                           |
%   errorCodeCnt = 0;                                                                                       |
%   for k = 3:length(ModSignal)                                                                             |
%       if ModSignal(k) ~= SymData(k);                                                                      |
%           errorCodeCnt = errorCodeCnt+1;                                                                  |
%       end                                                                                                 |
%   end                                                                                                     |
%------------------------------------------------------------------------------------------------------------
function [ constellationSignal, mm ] = pskDemodulation( SymData, Band, fs )

    inputDataLength       = length(SymData);
    samplingFrequency     = fs;
    symbolRate            = Band;
    outputDataLength      = inputDataLength; 

    Coff                            = zeros( 1, 4 );
    interpolatedFilterOutputDataQ   = zeros( 1, outputDataLength);
    interpolatedFilterOutputDataI   = zeros( 1, outputDataLength);
    interpolatedFilterBufferQ       = zeros( 1, 4 );
    interpolatedFilterBufferI       = zeros( 1, 4 );
    errDetecerOutputDataQ           = zeros( 1, outputDataLength);
    errDetecerOutputDataI           = zeros( 1, outputDataLength);
    errDetecerOutputData            = zeros( 1, outputDataLength);
    errDetecerBufferQ               = zeros( 1, 5 );
    errDetecerBufferI               = zeros( 1, 5 );
    symbolLoopFilterTempOutputData  = zeros( 1, outputDataLength);
    timingControlModData            = zeros( 1, outputDataLength);
    timingControlBuffer             = zeros( 1, 2 );
    symbolLoopFilterBuffer          = zeros( 1, 2 );
    mk                              = zeros( 1, outputDataLength); % Defined as symbol synchronized resample clock
    uk                              = zeros( 1, outputDataLength); % Defined as the symbol synchronization interpolation filter coefficient.
    resampleOutputData              = complex( zeros(1, outputDataLength), zeros(1, outputDataLength) );
    
    BLTS = 0.01;
    C1 = 8/5*BLTS;
    C2 = 32/9*BLTS^2;
%    BLTS = 0.01;
%    C1 = 8/3*BLTS;
%    C2 = 32/9*BLTS^2;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Symbol Synchronize<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
for n = 1: outputDataLength
    %-----------------------------------------InterpolatedFilter------------------------------------------%

    %-----------------Updata the coefficient of interpolated filter-----------------%
        Coff(1) = (1/6) *uk(n)^3 - (1/6)*uk(n);
        Coff(2) = (-1/2)*uk(n)^3 + (1/2)*uk(n)^2 +       uk(n);
        Coff(3) = (1/2) *uk(n)^3 -       uk(n)^2 - (1/2)*uk(n) + 1;
        Coff(4) = (-1/6)*uk(n)^3 + (1/2)*uk(n)^2 - (1/3)*uk(n);
    %---------------------------------------------------------------------------------%

        interpolatedFilterBufferQ(1) = real(SymData(n));
        interpolatedFilterBufferI(1) = imag(SymData(n));
        interpolatedFilterOutputDataQ(n) = Coff(1)*interpolatedFilterBufferQ(1) + Coff(2)*interpolatedFilterBufferQ(2) ...
                                         + Coff(3)*interpolatedFilterBufferQ(3) + Coff(4)*interpolatedFilterBufferQ(4);
        interpolatedFilterOutputDataI(n) = Coff(1)*interpolatedFilterBufferI(1) + Coff(2)*interpolatedFilterBufferI(2) ...
                                         + Coff(3)*interpolatedFilterBufferI(3) + Coff(4)*interpolatedFilterBufferI(4);
        for k = 1:3
            interpolatedFilterBufferQ(5-k) = interpolatedFilterBufferQ(4-k);
            interpolatedFilterBufferI(5-k) = interpolatedFilterBufferI(4-k);
        end

    %------------------------------------------------END--------------------------------------------------%
    %---------------------------------------------ErrDetecer-----------------------------------------------%

        errDetecerBufferQ(1) = interpolatedFilterOutputDataQ(n);
        errDetecerBufferI(1) = interpolatedFilterOutputDataI(n);
        errDetecerOutputDataQ(n) = (errDetecerBufferQ(1)-errDetecerBufferQ(5)) * errDetecerBufferQ(3);
        errDetecerOutputDataI(n) = (errDetecerBufferI(1)-errDetecerBufferI(5)) * errDetecerBufferI(3);
        errDetecerOutputData(n) = errDetecerOutputDataQ(n) + errDetecerOutputDataI(n);
        for k = 1:4
            errDetecerBufferQ(6-k) = errDetecerBufferQ(5-k);
            errDetecerBufferI(6-k) = errDetecerBufferI(5-k);
        end

    %------------------------------------------------END--------------------------------------------------%
    %--------------------------------------------LoopFilter----------------------------------------------%
          if mk(n) == 1
              symbolLoopFilterBuffer(1) = C2*errDetecerOutputData(n)+symbolLoopFilterBuffer(2);
              symbolLoopFilterTempOutputData(n) =  symbolLoopFilterBuffer(1) + C1*errDetecerOutputData(n);
              symbolLoopFilterBuffer(2) = symbolLoopFilterBuffer(1);
          else 
              symbolLoopFilterTempOutputData(n) = 0;
          end

    %------------------------------------------------END-------------------------------------------------%
    %-------------------------------------------TimingControl---------------------------------------------%

        timingControlModData(n) = mod(timingControlBuffer(2), 1);  
        timingControlBuffer(1) = timingControlModData(n) - symbolLoopFilterTempOutputData(n) - (1/(samplingFrequency/symbolRate));
        if timingControlBuffer(2) < timingControlModData(n)
            mk(n+1) = 1; 
        else
            mk(n+1) = 0;
        end
        if mk(n) == 1
            uk(n+1) = timingControlModData(n);
        end
        timingControlBuffer(2) = timingControlBuffer(1);

    %------------------------------------------------END-------------------------------------------------%
end

%-------------------------------------------Resample--------------------------------------------%

    cnt = 1;
    for n = 1: outputDataLength
        if mk(n) == 1
            resampleOutputData(cnt) = SymData(n);
            cnt = cnt + 1;
        end 
    end

%----------------------------------------------END-----------------------------------------------%
    constellationSignal = resampleOutputData(1:cnt-1);
    mm = mk(1:end-1);
    
end