# CC1350

**Instruções de Instalação:**

Requer Code Composer Studio versão 7, qualquer subversão.

1. Verificar se o "CC13xx/CC26xx Device Support" está atualizado. No CCS: "Help" -> "Check for Updates" -> Selecionar o CC13xx/CC26xx Device Support.
2. Baixar e instalar a SimpleLink CC13x0 SDK: http://www.ti.com/tool/download/SIMPLELINK-CC13X0-SDK
3. Descompactar rfPacketErrorRate.zip
4. No CCS: "File" -> "Import..." -> CCS Projects -> apontar para a pasta em que o rfPacketErrorRate.zip foi descompactado
5. Importar ambos os projetos. Porém, o único a ser utilizado é o rfPacketErrorRate_CC1350...

Duas opções de compilação: no arquivo **"menu.c"**, existe um **#define MATLAB**.

**1)** Se **#define MATLAB** estiver comentado, o firmware roda como no rfPacketErrorRate padrão da TI.
- Permite várias configurações de transmissão e recepção utilizando o TeraTerm (ou outro) para comunicação via serial (baud em 115200).

**2)** Se **#define MATLAB** estiver ativo, funciona sem o TeraTerm com configuração fixa de transmissão/recepção de 100000 pacotes, com modulação FSK, na frequência de 915kHz.
- Rodar na linha de comando do MATLAB: **dados = CC1350rssi(n_amostras)** e seguir as instruções.
- O botão esquerdo (BTN-1) configura o rádio como transmissor. O LED verde ficará piscando indicando que a transmissão está ocorrendo.
- O botão direito (BTN-2) configura o rádio como receptor. O LED vermelho ficará acesso esperando a transmissão ocorrer. Quando a transmissão iniciar, esse LED ficará piscando indicando a recepção.
