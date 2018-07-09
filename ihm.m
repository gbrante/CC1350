close all; clear; clc

display('configurando portal serial...')

% Ajustar de acordo com a COM correta
% Se rodar uma vez o MATLAB dá as opções possíveis
s1=serial('COM7','BaudRate',115200)
fopen(s1);
set(s1,'Timeout',120);
display('done')

% Numero de pacotes
imax = 1000;
contador=[];irssi=[];iCRC=[];
for i=1:imax
    a = fgets(s1);
    i
    contador(i)=str2double(a(1:5));    
    irssi(i)=str2double(a(6:10));
    iCRC(i)=str2double(a(11:15));
end
fclose(s1)

erros = [0 1-diff(iCRC)];
FER = sum(erros)/imax;
save fading.mat contador irssi iCRC erros FER

%%
figure(1)
subplot(2,1,1)
stem(contador,irssi)
title('RSSI x Amostras')
xlabel('Amostra')
ylabel('RSSI')
subplot(2,1,2)
stem(contador,erros)
title(['ERRO de Pacote x Amostras   -   FER = ' num2str(FER)])
xlabel('Amostra')
ylabel('ERRO')

%% Usar esses comandos caso o MATLAB "trave" a serial
newobjs = instrfind;
fclose(newobjs)