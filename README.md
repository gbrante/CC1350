# CC1350

**Instruções de Instalação:**

Requer Code Composer Studio versão 7, qualquer subversão.

Atualizar (ou instalar) CC13xx/CC26xx Device Support através do próprio CCS
1. Baixar e instalar a SimpleLink CC13x0 SDK: http://www.ti.com/tool/download/SIMPLELINK-CC13X0-SDK
2. Descompactar rfPacketErrorRate.zip
3. No CCS: "File" -> "Import..." -> CCS Projects -> apontar para a pasta em que o rfPacketErrorRate.zip foi descompactado
4. Importar ambos os projetos. Porém, o único a ser utilizado é o rfPacketErrorRate_CC1350...

Duas opções de compilação: no arquivo **"menu.c"**, existe um #define MATLAB.
1) Se **#define MATLAB** estiver comentado, o firmware roda como no rfPacketErrorRate padrão da TI.
- Permite várias configurações de transmissão e recepção utilizando o TeraTerm (ou outro) para comunicação via serial.

2) Se **#define MATLAB** estiver ativo, funciona em configuração padrão para transmissão/recepção de 1000 pacotes FSK em 915kHz
- O botão direito (BTN-2) configura o rádio como receptor. O LED vermelho ficará acesso esperando a transmissão ocorrerr. Quando a transmissão iniciar, esse LED ficará piscando indicando a recepção.
- Após pressionar o botão direito (BTN-2), rodar o **ihm.m** no MATLAB.
- O botão esquerdo (BTN-1) configura o rádio como transmissor. O LED verde ficará piscando indicando que a transmissão está ocorrendo.
