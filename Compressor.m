classdef Compressor < handle
    
    properties (Access = public)
        
    end
    
    properties (Access = private)
       keep
       signal
       data
    end
    
    methods (Access = public)
        
        function obj = Compressor(cParams)
            obj.init(cParams)            
        end

        function cData = computeCompressedSignal(obj)
            freq = obj.data.freq;
            freqCut = obj.cutFrequency(freq);
            fourier.type_ft = obj.data.type_ft;
            
            wave = obj.data.wave;
            wCut = obj.cutWave(wave);
            wavelet.type_wt = obj.data.type_wt;
            
            U = obj.data.U;
            S = obj.data.S;
            V = obj.data.V;
            
            [Ucut,Scut,Vcut] = obj.cutPCA(U,S,V);
            
            fourier.type = 'FOURIER';
            wavelet.type = 'WAVELET';
            pca.type = 'PCA';
            
            fourier.dim = obj.data.dim;
            wavelet.dim = obj.data.dim;
            pca.dim = obj.data.dim;
            
            fourier.freq = freqCut;
            wavelet.wave = wCut;
            wavelet.motherwave = obj.data.motherwave;
            wavelet.wave_info = obj.data.wave_info;
            
            pca.U = Ucut;
            pca.S = Scut;
            pca.V = Vcut;
                
            s = struct('Fourier',Data(fourier),'Wavelet',Data(wavelet),'PCA',Data(pca));
            cData = s;
        end
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.keep = cParams.keep;
            obj.data = cParams.data;
        end
        
        function  fCut = cutFrequency(obj,freq)
            if obj.keep == 1
                fCut = freq;
            else
                freqSort = sort(abs(freq(:)));
                thresh = freqSort(floor((1-obj.keep)*length(freqSort)));
                ind    = abs(freq)>thresh;   
                fCut = freq.*ind;           
            end 
        end
        
        function  wCut = cutWave(obj,wave)
            if obj.keep == 1
                wCut = wave;
            else
                waveSort = sort(abs(wave(:)));
                thresh = waveSort(floor((1-obj.keep)*length(waveSort)));
                ind    = abs(wave)>thresh;   
                wCut = wave.*ind;           
            end 
        end
        
        function [Ucut,Scut,Vcut] = cutPCA(obj,U,S,V)  
            nx = size(U,1);
            ny = size(V,2);
            
            %Aqui el cut todavia no esta bien 
            %r = round((nx*ny)*(obj.keep/3));
            %r = round(length(S)*(obj.keep/3));
            r = 1;
            Ucut = U(:,1:r);
            Scut = S(1:r,1:r);
            Vcut = V(:,1:r);
        end
        
    end
    
end