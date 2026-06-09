# Como configurar/instalar/usar o `configure message before login` no `Linux Ubuntu` pelo `Terminal Emulator`

## Resumo

Neste documento estão contidos os principais comandos e configurações para configurar/instalar/usar 
o `configure message before login` no `Linux Ubuntu`.

## _Abstract_

_This document contains the main commands and settings to configure/install/use the `configure message before login` in `Linux Ubuntu`._

## Descrição [2]

### `lightdm`

O `LightDM` é um gerenciador de exibição (_display manager_) de código aberto amplamente utilizado 
em sistemas operacionais `Linux`. Ele é responsável por fornecer uma _interface_ gráfica de _login_ 
para os usuários, permitindo que eles escolham suas contas e iniciem sessão em um ambiente gráfico, 
como o ambiente de _desktop_ `Unity`, `GNOME` ou `Xfce`. O `LightDM` é altamente personalizável e 
suporta temas para personalizar a aparência da tela de _login_. Além disso, é uma peça fundamental 
em distribuições `Linux` populares, como o `Ubuntu`, que o utiliza como gerenciador de exibição 
padrão. Sua natureza flexível e modular o torna uma escolha versátil para diferentes ambientes de 
_desktop_ e requisitos de personalização.

### `zenity`

O `Zenity` é uma ferramenta de linha de comando de código aberto que permite criar _interfaces_ 
gráficas de usuário (GUI) simples a partir do `Terminal Emulator` em sistemas `Linux`. Ele é 
projetado para facilitar a interação do usuário com _scripts_ e programas por meio de caixas de 
diálogo, janelas de seleção e outros elementos de _interface_ gráfica. O `Zenity` é especialmente 
útil para automação de tarefas, _scripts_ de _shell_ e aplicativos que desejam fornecer uma 
experiência de usuário mais amigável, mesmo quando executados em um ambiente de `Terminal Emulator`.
Com suporte para várias linguagens de programação, como `Bash`, `Python` e `Perl`, o `Zenity` torna 
mais fácil criar caixas de diálogo personalizadas e interativas para solicitar entrada do usuário, 
exibir mensagens informativas ou fornecer opções de escolha, melhorando a usabilidade de _scripts_ e
aplicativos no `Linux`.

## 1. Como configurar/instalar/usar o `configure message before login` no `Linux Ubuntu` [1]

Vale ressaltar que alguns sistemas operacionais voltados para segurança e pentest, como o `Kali Linux`, podem já possuir ferramentas similares instaladas nativamente. No entanto, as instruções abaixo descrevem como realizar a instalação e configuração manual, como se o recurso não existisse no sistema.

Para configurar/instalar/usar o `configure message before login` no `Linux Ubuntu`, você pode seguir estes passos:

1. Abrir o `Terminal Emulator`. Você pode fazer isso pressionando:

    ```bash
    Ctrl + Alt + T
    ```

2. Certifique-se de que seu sistema esteja limpo e atualizado.

    2.1 Limpar o `cache` do gerenciador de pacotes `apt`. Especificamente, ele remove todos os arquivos de pacotes (`.deb`) baixados pelo `apt` e armazenados em `/var/cache/apt/archives/`. Digite o seguinte comando:
    ```bash
    sudo apt clean
    ```
    
    2.2 Remover pacotes `.deb` antigos ou duplicados do `cache` local. É útil para liberar espaço, pois remove apenas os pacotes que não podem mais ser baixados (ou seja, versões antigas de pacotes que foram atualizados). Digite o seguinte comando:
    ```bash
    sudo apt autoclean
    ```

    2.3 Remover pacotes que foram automaticamente instalados para satisfazer as dependências de outros pacotes e que não são mais necessários. Digite o seguinte comando:
    ```bash
    sudo apt autoremove -y
    ```

    2.4 Buscar as atualizações disponíveis para os pacotes que estão instalados em seu sistema. Digite o seguinte comando e pressione `Enter`:
    ```bash
    sudo apt update
    ```

    2.5 **Corrigir pacotes quebrados**: Isso atualizará a lista de pacotes disponíveis e tentará corrigir pacotes quebrados ou com dependências ausentes:
    ```bash
    sudo apt --fix-broken install
    ```

    2.6 Limpar o `cache` do gerenciador de pacotes `apt` novamente:
    ```bash
    sudo apt clean
    ```
    
    2.7 Para ver a lista de pacotes a serem atualizados, digite o seguinte comando e pressione `Enter`:
    ```bash
    sudo apt list --upgradable
    ```

    2.8 Realmente atualizar os pacotes instalados para as suas versões mais recentes, com base na última vez que você executou `sudo apt update`. Digite o seguinte comando e pressione `Enter`:
    ```bash
    sudo apt full-upgrade -y
    ```

## 2. Usar um _script_ de _greeter_

Uma maneira de garantir que a mensagem seja mostrada é usar um _script_ de greeter personalizado que
será executado antes da tela de _login_. Este _script_ pode criar uma janela de diálogo ou algo 
similar para mostrar a mensagem. O `zenity` é uma ferramenta que pode ser usada para criar uma 
janela de mensagem gráfica a partir de um _script_.

1. **Instalar o `Zenity` (se ainda não estiver instalado):**

    ```bash
    sudo apt install zenity -y
    ```

2. **Criar o _script_ de Mensagem:** Crie um novo arquivo de _script_. Por exemplo, 
`login_message.sh` em `/usr/local/bin/` com o comando:

    ```bash
    sudo nano /usr/local/bin/login_message.sh
    ```

3. **Adicione o seguinte conteúdo ao arquivo:**

    ```bash
    #!/bin/bash
    zenity --info --no-wrap --text="ATTENTION! \n\n EDF Technology, based on current labor legislation, reserves the right to audit and monitor the equipment and systems made available by it. \n Therefore, this equipment and / or system should only be used for corporate purposes of interest to the Company, if you have doubts about your permission to access it, \n and immediately, as the unauthorized use can be characterized by misuse and non-observance of the internal regulations, which may subject the employee to disciplinary penalties pertaining to the Information Security Policy and the Code of Conduct and Ethics. \n The actions performed on this equipment are monitored, which gives the owner the right to use them for any purpose." --title="EDF Technology" --width=1280 --height=720
    ```

4. **Tornar o _script_ executável:**

    ```bash
    sudo chmod +x /usr/local/bin/login_message.sh
    ```

5. **Modificar a Configuração do `lightdm` para Executar o _script_:** Edite ou crie o arquivo de 
configuração do `lightdm` como mencionado anteriormente, adicionando a linha para executar o 
_script_ de mensagem:
    
    ```bash
    sudo nano /etc/lightdm/lightdm.conf.d/50-my-custom.conf
    ```

    5.1 **Adicione ou modifique a seguinte linha:** 

    ```bash
    [Seat:*]
    greeter-setup-script=/usr/local/bin/login_message.sh
    ```

6. **Reinicie o `lightdm` ou o Computador:**

    ```bash
    sudo systemctl restart lightdm
    ```

### 3. Código completo para configurar/instalar/usar

Para configurar/instalar/usar o `configure message before login` no `Linux Ubuntu` sem precisar digitar 
linha por linha, você pode seguir estas etapas:

1. Abrir o `Terminal Emulator`. Você pode fazer isso pressionando:

    ```bash
    Ctrl + Alt + T
    ```

2. Digitar o seguinte comando e pressione `Enter`:

    ```
    NÂO há.
    ```

## Referências

[1] OPENAI. **Instalar o `configure message before login` no `linux ubuntu` pelo `terminal emulator`**. Disponível em: <https://chatgpt.com/g/g-p-6980caf949648191ad6acfcdbe590f9e-instalar/c/4823d7e8-3996-46c5-ac88-8131da2ea769>. ChatGPT. Acessado em: 09/06/2026.

[2] OPENAI. **Vs code: editor popular**. Disponível em: <https://chat.openai.com/c/b640a25d-f8e3-4922-8a3b-ed74a2657e42>. ChatGPT. Acessado em: 09/06/2026.
