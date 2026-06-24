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
será executado antes da tela de _login_. Este _script_ cria uma janela de aviso com `zenity` e,
depois que o aviso é fechado, inicia um _helper_ de auto-submit do `LightDM`.

O _helper_ não faz _autologin_. Ele monitora `/var/log/lightdm/lightdm.log` e só envia `Return` ao
`lightdm-gtk-greeter` quando o `PAM` registra autenticação bem-sucedida para `edenedfsls`, por
exemplo após reconhecimento facial pelo `howdy`.

1. **Instalar dependências:**

    ```bash
    sudo apt install -y zenity xdotool
    ```

2. **Instalar os scripts versionados:**

    ```bash
    cp scripts/srv_login_message.sh /home/edenedfsls/.local/bin/srv_login_message.sh
    cp scripts/srv_lightdm_auto_submit.sh /home/edenedfsls/.local/bin/srv_lightdm_auto_submit.sh
    chmod +x /home/edenedfsls/.local/bin/srv_login_message.sh
    chmod +x /home/edenedfsls/.local/bin/srv_lightdm_auto_submit.sh
    ```

3. **Configurar o `LightDM` para executar o script de aviso:**

    ```bash
    sudo mkdir -p /etc/lightdm/lightdm.conf.d
    sudo tee /etc/lightdm/lightdm.conf.d/50-my-custom.conf >/dev/null <<'EOF'
    [Seat:*]
    greeter-setup-script=/home/edenedfsls/.local/bin/srv_login_message.sh
    EOF
    ```

4. **Reiniciar o `lightdm` ou o computador:**

    ```bash
    sudo systemctl restart lightdm
    ```

5. **Validar o resultado:**

   Após o aviso inicial, o greeter deve iniciar o fluxo normal de autenticação. Quando o `howdy`
   reconhecer o rosto e o `PAM` registrar sucesso, o _helper_ envia `Return` para acionar o botão
   `Log in` automaticamente.

   Se o rosto não for reconhecido, o fluxo continua pedindo senha; o _helper_ não ignora senha e
   não altera a autenticação do `PAM`.

6. **Depuração:**

    ```bash
    tail -n 80 /var/log/lightdm/lightdm.log
    tail -n 80 /var/log/lightdm/seat0-greeter.log
    ```

### 3. Código completo para configurar/instalar/usar

Para configurar/instalar/usar o `configure message before login` no `Linux Ubuntu` sem precisar digitar 
linha por linha, você pode seguir estas etapas:

1. Abrir o `Terminal Emulator`. Você pode fazer isso pressionando:

    ```bash
    Ctrl + Alt + T
    ```

2. Digitar o seguinte comando e pressione `Enter`:

    ```bash
    cd /home/edenedfsls/Documents/Downloads/unix/ubuntu/commands_and_settings/configure_message_before_login
    sudo apt install -y zenity xdotool
    cp scripts/srv_login_message.sh /home/edenedfsls/.local/bin/srv_login_message.sh
    cp scripts/srv_lightdm_auto_submit.sh /home/edenedfsls/.local/bin/srv_lightdm_auto_submit.sh
    chmod +x /home/edenedfsls/.local/bin/srv_login_message.sh
    chmod +x /home/edenedfsls/.local/bin/srv_lightdm_auto_submit.sh
    sudo mkdir -p /etc/lightdm/lightdm.conf.d
    sudo tee /etc/lightdm/lightdm.conf.d/50-my-custom.conf >/dev/null <<'EOF'
    [Seat:*]
    greeter-setup-script=/home/edenedfsls/.local/bin/srv_login_message.sh
    EOF
    sudo systemctl restart lightdm
    ```

## Referências

[1] OPENAI. **Instalar o `configure message before login` no `linux ubuntu` pelo `terminal emulator`**. Disponível em: <https://chatgpt.com/g/g-p-6980caf949648191ad6acfcdbe590f9e-instalar/c/4823d7e8-3996-46c5-ac88-8131da2ea769>. ChatGPT. Acessado em: 09/06/2026.

[2] OPENAI. **Vs code: editor popular**. Disponível em: <https://chat.openai.com/c/b640a25d-f8e3-4922-8a3b-ed74a2657e42>. ChatGPT. Acessado em: 09/06/2026.
