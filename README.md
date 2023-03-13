# Guia de um projeto básico em C

Termos técnicos usados ao longo do documento:  
**CC:** C Compiler (Seja ele o gcc, clang ou outro).  
**\*:** wildcard ("\*.exe" leia-se como "qualquer-coisa.exe" ).  
**Terminal:** Interpretador de comandos do sistema (CMD ou PowerShell no Windows).  

## Diretórios

Projetos em C normalmente são organizados em sub-diretórios, nos quais o código fonte é distribuído seguindo algum tipo de padrão.

Os diretórios deste projeto estão organizados da seguinte forma:  
**bin/** --> Arquivos binários (normalmente gerados pelo CC)  
**include/** --> Cabeçalhos de C (arquivos "\*.h")  
**obj/** --> Arquivos de objeto (arquivos "\*.o") normalmente gerados pelo CC  
**src/** --> Código fonte em C (arquivos "\*.c")

## makefile

É o arquivo que será executado pelo comando **make**. Ele contém instruções de como unir os arquivos do projeto e compilá-los para um executável.  
A makefile é o que permite que este projeto seja compilado de maneira fácil sem depender de uma IDE específica, assim todos têm a liberdade de escolher a IDE ou editor de texto que preferir.

Normalmente, basta digitar "make" no terminal enquanto está no diretório do projeto para que ele seja compilado.

### Como funciona a makefile deste projeto

**make** --> Compilar programa.  
**make forWindows** --> Compilar programa para Windows a partir de um sistema Linux.  
**make release** --> Compilar programa com flags que possibilitem um executável eficiente para o usuário final.  
**make submit** --> Criar um arquivo zip de todo o projeto.  
**make run** --> Compilar e executar o programa (apenas executa caso o binário já exista).  
**make clean** --> Remover arquivos que podem ser gerados novamente (binários, objetos e ZIP do projeto).  
**make genconfig-linux** --> Gera o arquivo "compile_commands.json", usado pelo clangd para interpretar corretamente a organização do projeto. No momento funciona apenas no Linux.  

Sinta-se livre para alterar a makefile de acordo com as necessidades do projeto.  

# Instalando software

## Instalando make no Linux

Praticamente todos os sistemas Linux já vêm com o make instalado, mas se você estiver utilizando uma distribuição muito estranha, siga os passos a seguir:

1. Baixe a última versão do make [neste link](http://ftpmirror.gnu.org/make/). Dê preferência a um arquivo *.tar.gz para maior compatibilidade.
2. Extraia o arquivo e siga as instruções no README extraído.

## Instalando GCC no Linux

Todos os Linux já vem com o GCC instaldo. Se a sua distribuição é psicopata a ponto de não vir com o gcc instalado, repense as escolhas da sua vida.

## Instalando make no Windows

Será instalado através do *chocolatey*.

1. Abra o PowerShell no modo administrador.
    1. Insira `Get-ExecutionPolicy`. Se o comando retornar `Restricted`, insira `Set-ExecutionPolicy AllSigned`
        1. A seguinte mensagem será exibida:
           ```
            Alteração da Política de Execução
            A política de execução ajuda a proteger contra scripts não confiáveis. A alteração da política de execução pode
            implicar exposição aos riscos de segurança descritos no tópico da ajuda about_Execution_Policies em
            https://go.microsoft.com/fwlink/?LinkID=135170. Deseja alterar a política de execução?
            [S] Sim  [A] Sim para Todos  [N] Não  [T] Não para Todos  [U] Suspender  [?] Ajuda (o padrão é "N"):
            ```
        2. Responda "s".
    2. Insira `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`
    3. Aguarde a instalação.
    4. Feche o PowerShell.
2. Abra o CMD (Prompt de Comando) ou PowerShell no modo administrador.
    1. Insira `choco` para verificar se a instalação foi bem sucedida.
    2. Insira `choco install make` para finalmente instalar o make.
3. make já está instalado. Quando for necessário atualizá-lo, digite `choco upgrade make` no CMD ou PowerShell no modo administrador.

## Instalando GCC no Windows

Se você tem o Code::Blocks instalado no seu PC, você provavelmente já tem o gcc instalado também.  
Verifique se o gcc está instalado digitando `gcc --version` no teminal.  
Caso ainda não esteja instalado...

1. Instale o *cholatey* assim como foi descrito no primeiro passo de "Instalando make no Windows".
2. Abra um terminal no modo administrador.
3. `choco install mingw`
    1. Caso a mensagem abaixo apareça, responda "Y".
       ```
        Chocolatey v1.2.0
        Installing the following packages:
        mingw
        By installing, you accept licenses for the packages.
        Progress: Downloading mingw 12.2.0... 100%
        
        mingw v12.2.0 [Approved]
        mingw package files install completed. Performing other installation steps.
        The package mingw wants to run 'chocolateyinstall.ps1'.
        Note: If you don't run this script, the installation will fail.
        Note: To confirm automatically next time, use '-y' or consider:
        choco feature enable -n allowGlobalConfirmation
        Do you want to run the script?([Y]es/[A]ll - yes to all/[N]o/[P]rint):
        ```
    2. Aguarde a instalação (pode demorar mais que o esperado).
4. Feche o terminal e abra-o novamente (dessa vez não é necessário o modo administrador).
5. Para verificar se a instalação ocorreu com êxito, digite `gcc --version`.

# Boas práticas para este projeto em C

- Dar preferência a utilizar funções da biblioteca padrão do C
- Não utilizar funções com comportamento indefinido ou que funcionam apenas sob condições específicas. Funções do tipo incluem:
    - fflush(stdin): Comportamento indefinido e só funciona no Windows
    - setbuf(stdin, NULL): Comportamento indefinido e às vezes funciona apenas no Linux
    - __fpurge(stdin): Não faz parte da biblioteca padrão, mas é a melhor opção para limpar o buffer quando está disponível
    - fseek(stdin, 0, SEEK_END): Comportamento indefinido
    - Apesar de não ser uma função, a palavra-chave *typeof* não faz parte da sintaxe padrão do C (ainda)
- Comentar o que cada função faz, inclusive em arquivos \*.h (a menos que ela seja extremamente simples)
- Aritmética de ponteiros void tem comportamento indefinido no C padrão. Por conta disso, o makefile deste projeto desativa isso para o GCC

# Boas práticas para git

- O git não se dá muito bem com arquivos que não sejam de texto. Enviar arquivos binários para o repositório pode fazê-lo crescer muito em tamanho, por isso não envie algo como o executável do programa para o repositório.  
O arquivo ".gitignore" tenta evitar que isso aconteça.
- Evite ao máximo utilizar `git -f` ou `git --force`
- Faça commit de vários arquivos ao mesmo tempo somente se eles estiverem relacionados de alguma forma. Caso contrário, pode ser uma boa ideia dividir os arquivos em 2 ou mais commits.
- Não envie código não testado para a branch main
- Crie sua própria branch para fazer modificações no código e depois dê pull-request.

# Setup open-source para Windows 10+ (opcional)

É o mais open-souce que consegui fazer. Windows dificulta muito as coisas.  
O VSCodium é uma versão open-source do VSCode. Ele é fácil de usar e tem um grande suporte da comunidade com extensões.
Ao final, você terá com editor com:
- Sintaxe destacada e colorida
- Indicação de erros no código
- Sugestões automáticas de boas práticas
- Navegação do código-fonte fácil (Segure Ctrl + clique em uma função ou cabeçalho #include para ir automaticamente para a sua definição, mesmo que esteja em um arquivo diferente)
- Terminal integrado (Ctrl + Shift + ' para abrir um novo terminal)
- Git integrado (painel esquerdo "Controle do código-fonte")
- Depurador (debugger) nativo compatível com o GDB e LLDB

1. abra o CMD e insira os seguintes comandos:
    ```
    winget install VSCodium.VSCodium
    winget install MSYS2.MSYS2
    ```
2. Após a instalação, abra o "MSYS2 MSYS" que acabou de ser instalado, e insira o seguinte comando nele: (É possível colar no terminal com o botão "Insert" do teclado)
    `pacman -Syu mingw-w64-x86_64-clang mingw-w64-x86_64-clang-tools-extra`
3. Após a instalação, aperte Win + Q e pesquise por "variáveis de ambiente". Selecione a opção que contenha algo como "Editar as variáveis de ambiente do sistema"
    1. Clique em "Variáveis de Ambiente..."
    2. Selecione a variável "Path" na lista
    3. Clique em editar
    4. Clique em novo
    5. Adicione `C:\msys64\mingw64\bin` na lista
    6. Clique em "OK" em todas as janelas que foram abertas até então.
4. Abra o VSCodium
    1. Vá até o painel de extensões (lado esquerdo da tela) e instale as extensões "clangd", "Clang-Tidy" e "Native Debug". Basta pesquisar o nome das extensões para que elas apareçam.  
    Opcionalmente instale "Portuguese (Brazil) Language Pack for Visual Studio Code" para que o editor fique em português
    2. Vá em *Arquivo > Abrir Pasta* e abra a pasta deste repositório
    3. Crie um arquivo chamado "compile_flags.txt" e insira o seguinte conteúdo nele: (Você pode criar o arquivo utilizando o próprio VSCodium)
        ```
        -I
        include
        ```  
        Esse arquivo indica onde os arquivos *.h estão localizados
    4. Crie um arquivo chamado "tasks.json" e insira o seguinte conteúdo nele:
        ```
        {
            // See https://go.microsoft.com/fwlink/?LinkId=733558
            // for the documentation about the tasks.json format
            "version": "2.0.0",
            "tasks": [
                {
                    "label": "make run",
                    "type": "shell",
                    "command": "make run",
                    "problemMatcher": [],
                    "group": {
                        "kind": "build",
                        "isDefault": true
                    }
                }
            ]
        }
        ```  
        Esse arquivo permite que você compile e execute o código automaticamente através do menu *Terminal > Executar tarefa de build*
    5. Crie um arquivo chamado "launch.json" e insira o seguinte conteúdo nele:
        ```
        {
            // Use o IntelliSense para saber mais sobre os atributos possíveis.
            // Focalizar para exibir as descrições dos atributos existentes.
            // Para obter mais informações, acesse: https://go.microsoft.com/fwlink/?linkid=830387
            "version": "0.2.0",
            "configurations": [
                {
                    "name": "Debug",
                    "type": "gdb",
                    "request": "launch",
                    "target": "./bin/main.exe",
                    "cwd": "${workspaceRoot}",
                    "valuesFormatting": "parseText"
                }
            ]
        }
        ```  
        Esse arquivo serve para o depurador saber onde está localizado o executável que será depurado (além de outras configurações relacionadas)

