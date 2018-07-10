function saida = CC1350rssi(n_amostras)
% Descrição:
%
% Esta função inicializa uma comunicação serial com um CC1350 conectado no
% computador. Se houver mais de um CC1350 conectado, ele seleciona
% automaticamente o primeiro que estiver disponível.
% A saída da função é um vetor contendo o índice de cada pacote recebido, o
% número de erros ocorridos até aquele pacote e a potência instantânea
% (RSSI) do pacote.
% Durante a execução, é apresentado ao usuário - na janela de comando do
% Matlab - as informações coletadas.
%
% Sintaxe:
% dados = CC1350rssi(n_amostras)
%
% Parâmetro:
% n_amostras -> Número de amostras que serão coletadas durante a execução
%

idCOM{1} = '0'; % Celula (lista) com nomes das COMs
nCOM = 0; % Numero de CC1350 encontrados

if ispc % O codigo abaixo funciona para Windows
    % Funcao que retorna informacao das portas COM Para localizar se algum CC1350 esta conectado
    [~,info] = system('wmic path Win32_SerialPort');
    
    % Encontra a porta COM relativa a cada CC1350
    registros = regexp(info,'User UART \(COM\d\)','match');
       
    if ~isempty(registros) % Se houver algum CC1350 conectado - funciona da COM1-COM9
        for k=1 : length(registros)
            % Variavel aux recebe o numero de cada porta CC1350
            aux = regexp(registros{k},'COM\d','match','once');           
            
            for m=1 : length(idCOM)
                if strcmp(aux,idCOM{m}) % Compara se ja existe esta COM na lista
                    existeCOM = true;
                    break % Se houver uma igual pode interromper o "for"
                else
                    existeCOM = false;
                end
            end
            if ~existeCOM
                nCOM = nCOM + 1; % Incrementa numero de portas diferentes
                idCOM{nCOM} = aux; % Se nao houver a COM "aux" na lista, ela e adicionada
            end
        end
    else % Testa COM10-COM19
        registros = regexp(info,'User UART \(COM\d\d\)','match');
        if ~isempty(registros) % Se houver algum CC1350 conectado
            for k=1 : length(registros)
                % Variavel aux recebe o numero de cada porta COM
                aux = regexp(registros{k},'COM\d\d','match','once');
                
                for m=1 : length(idCOM)
                    if strcmp(aux,idCOM{m}) % Compara se ja existe esta COM na lista
                        existeCOM = true;
                        break % Se houver uma igual pode interromper o "for"
                    else
                        existeCOM = false;
                    end
                end
                if ~existeCOM
                    nCOM = nCOM + 1; % Incrementa numero de portas diferentes
                    idCOM{nCOM} = aux; % Se nao houver a COM "aux" na lista, ela e adicionada
                end
            end
        end
    end
else % Se o computador for MAC ou Linux, o usuario deve digitar o nome da porta COM
    % Encontra as portas serial conectadas
    serials = instrhwinfo('serial');
    disp('O CC1350 está em qual das portas COM abaixo?');
    disp(serials.AvailableSerialPorts);
    idCOM{1} = input('','s');
end

% Verifica se tem algum CC1350 conectado
if isempty(idCOM) % Caso nenhuma COM tenha sido encontrada com Kico
    disp('Não foi encontrado nenhum CC1350 conectado ao computador');
else
    % Encontra todas as comunicacoes tipo serial no PC
    serials = instrhwinfo('serial');
    
    % Serve para comparar os CC1350 encontrados com os disponiveis
    for k=1 : length(idCOM)
        % Comparacao se os CC1350 encontrados estao disponiveis
        CC1350Disp = strcmp(idCOM{k},serials.AvailableSerialPorts);
        % Encontra o indice da primeira COM disponivel
        [~,index] = max(CC1350Disp);
        
        if any(CC1350Disp == 1) % Se houve algum CC1350 disponivel
            % Salva a COM do CC1350 que sera usado
            CC1350 = serials.AvailableSerialPorts{index};
            break
        else
            % Nenhum CC1350 esta disponivel
            CC1350 = 0;
        end
    end
    
    if CC1350 == 0
        disp('Nenhum CC1350 disponível');
    else
        disp(['Conectando com o CC1350 na ',CC1350]);
        
        % Try pois pode haver alguma excessao na comunicacao serial
        % E independente deste erro, a comunicacao deve ser encerrada
        % corretamente com fclose(.) e delete(.)
        try
            % Comunicação serial
            s = serial(CC1350,'BaudRate',115200);
            fopen(s);
            fprintf('\nPronto para iniciar a comunicação\n\nPressione BTN-2 para configurar o CC1350 como receptor\nVocê deverá enxergar o LED vermelho acesso após pressionar BTN-2\n\n');
            set(s,'Timeout',inf);
            
            % Aguarda botão ser pressioando
            a = fgetl(s);
            disp('RX <--');
            disp('Pressione BTN-1 no CC1350 transmissor');
            disp('LEDs verde\vermelho irão piscar no transmissor\receptor indicando comunicação');
            
            % Variavel caso haja erro, para correto termino da conexao serial
            erro = false;
            
            contador = zeros(n_amostras,1);
            rssi = zeros(n_amostras,1);
            erros = zeros(n_amostras,1);
                
            % Coleta amostras
            for k=1:n_amostras
                a = fgetl(s); %Salva a string enviada pelo CC1350
                while (length(a) ~= 16)
                    a = fgetl(s);
                end
                    
                contador(k)=str2double(a(1:5));
                rssi(k)=str2double(a(6:10));
                erros(k)=str2double(a(11:15));
                    
                % Mostra resultados no matlab
                clc
                disp('     N#     ;     ERROS     ;      RSSI');
                fprintf('%09i       %09i        %03.0f dBm\n', contador(k), erros(k), rssi(k));
            end
        catch err
            % Se houve erro, termina a comunicacao serial
            fclose(s);
            delete(s);
            
            % Para identificar que houve erro
            erro = true;
            rethrow(err);
        end
    end
    % Se nao houve erro
    if ~erro
        % Encerra a comunicacao serial
        fclose(s);
        delete(s);
    end
end

saida = [contador erros rssi];

erros = [0; diff(erros)];
FER = sum(erros)/n_amostras;

figure
subplot(2,1,1)
plot(contador,rssi)
title('RSSI x Amostras')
xlabel('Amostra')
ylabel('RSSI')
subplot(2,1,2)
stem(contador,erros)
title(['ERRO de Pacote x Amostras   -   FER = ' num2str(FER)])
xlabel('Amostra')
ylabel('ERRO')
