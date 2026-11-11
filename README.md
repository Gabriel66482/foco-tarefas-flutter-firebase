# Foco - gerenciador de tarefas

Projeto P2 de Programação Mobile em Flutter/Dart. Inclui Firebase Authentication, Realtime Database e SharedPreferences, com versões Android e web a partir do mesmo código.

## Pronto nesta máquina

O Firebase **foco-tarefas-p2** está configurado na conta pessoal, no plano Spark. E-mail/senha está ativado; o Realtime Database usa regras por UID. Os apps web e Android estão registrados e os arquivos de configuração de cliente estão incluídos. Esses arquivos contêm identificadores públicos do SDK, sem senha, token administrativo ou conta de serviço.

No VS Code, selecione **Foco - Firebase nuvem (web)** e pressione F5. A execução usa Microsoft Edge em <http://127.0.0.1:7358>. O APK de entrega está disponível junto da pasta do projeto como `Foco-Android.apk`. Ele usa o mesmo Firebase real. Para gravar no celular, instale o APK e mantenha conexão com a internet.

## Funcionalidades

- Cadastro com nome, e-mail, senha e confirmação; login/logout, validação, mensagens em português e sessão persistida pelo Firebase.
- Início com nome e totais de tarefas cadastradas, pendentes e concluídas.
- Drawer: Início, Minhas tarefas, Configurações, Sobre o aplicativo e Sair; nome/e-mail no cabeçalho.
- Tarefas com título, descrição, vencimento, prioridade baixa/média/alta e situação pendente/concluída.
- ListView, detalhes, cadastro, edição, exclusão confirmada, filtros e mudança de situação nos dois sentidos.
- Listeners `onValue`, dados em `usuarios/{uid}/tarefas/{id}` e regras que impedem acesso entre contas.
- ThemeData claro/escuro e ThemeMode global; preferência salva com SharedPreferences.

## Ambiente e execução no VS Code

Nesta máquina foram preparados Flutter 3.47.9 / Dart 3.13.7, Java 21, SDK Android e extensão oficial Flutter/Dart do VS Code. Os SDKs ficam em `../../work`, fora do repositório. Em outra máquina, instale essas ferramentas e ajuste/remova `dart.flutterSdkPath` em `.vscode/settings.json` para usar seu SDK. As dependências estão fixadas nos arquivos de lock.

Abra a pasta deste projeto no VS Code. Se aparecer Restricted Mode, confira a pasta e autorize a confiança **somente neste projeto** para permitir depuração.

### Ensaio com os emuladores oficiais do Firebase

No terminal, na raiz do projeto:

```powershell
./scripts/flutter.ps1 pub get
pnpm install --frozen-lockfile --ignore-scripts
./scripts/emulators.ps1
```

Sem pnpm, `npm install` também instala as ferramentas Node. O script usa o Java preparado neste chat; em outra máquina, instale Java 21 e configure JAVA_HOME. Mantenha esse terminal aberto. Interface Firebase local: <http://127.0.0.1:4000>, Authentication: `/auth`, banco: `/database`.

Em outro terminal:

```powershell
./scripts/flutter.ps1 run -d web-server --web-hostname 127.0.0.1 --web-port 7357 --dart-define-from-file=config/emulators.json
```

Abra <http://127.0.0.1:7357> depois que a compilação terminar. Ou selecione **Foco - Firebase local (web)** em Executar e Depurar e pressione F5. A mesma URL/porta e perfil do navegador devem ser usados para preservar sessão e preferências.

Use apenas dados fictícios nos emuladores. Nenhuma conta/senha foi embutida no aplicativo. O script importa/exporta `.firebase-data/` ao encerrar normalmente com Ctrl+C; essa pasta não é versionada. Emuladores não equivalem a armazenamento na nuvem.

### Firebase na nuvem

1. No [console Firebase](https://console.firebase.google.com/), use a conta pessoal e um projeto no plano **Spark**, sem faturamento. Analytics/Gemini não são necessários.
2. Em **Authentication > Método de login**, habilite **E-mail/senha**.
3. Crie um **Realtime Database** em modo bloqueado. Publique nele o conteúdo de `database.rules.json`. Não use regras públicas. Copie a URL exata do banco, que depende da região.
4. Registre um app **web** e copie os valores públicos da configuração: apiKey, appId, projectId, messagingSenderId e authDomain.
5. Copie `config/firebase.example.json` para `config/firebase.json` e preencha os valores e a URL do banco. Mantenha USE_FIREBASE_EMULATORS=false. O projeto entregue já inclui essa configuração de cliente; a autorização real é feita por Authentication e pelas regras por UID.
6. Verifique `localhost`/`127.0.0.1` em Authentication > Configurações > Domínios autorizados se o serviço exigir para a apresentação local.

```powershell
./scripts/flutter.ps1 run -d web-server --web-hostname 127.0.0.1 --web-port 7357 --dart-define-from-file=config/firebase.json
```

Ou selecione **Foco - Firebase nuvem (web)** no VS Code, que usa Edge e a porta 7358. Contas e tarefas locais não são transferidas automaticamente para a nuvem. As etapas acima já foram realizadas no projeto entregue; use-as para reproduzir em outro projeto Firebase.

Para publicar regras pela CLI:

```powershell
./scripts/firebase.ps1 login
./scripts/firebase.ps1 deploy --only database --project SEU_PROJECT_ID
```

No fluxo de login remoto, o código longo que começa com `4/` é o código de autorização. O identificador curto de sessão não serve para concluir o login. Nunca coloque códigos, tokens, senhas ou contas de serviço no Git.

### Android

Registre o app Android com pacote **br.edu.unigran.foco_tarefas** no mesmo Firebase. Baixe `google-services.json` para `android/app/` e preencha `config/firebase.android.json` no formato do exemplo, usando appId/chave do app Android. O código inicializa explicitamente com FirebaseOptions, sem depender do plugin Gradle Google Services.

Com dispositivo USB ou Android Emulator configurado:

```powershell
./scripts/flutter.ps1 run -d ID_DO_ANDROID --dart-define-from-file=config/firebase.android.json
./scripts/flutter.ps1 build apk --debug --dart-define-from-file=config/firebase.android.json
```

O APK sai em `build/app/outputs/flutter-apk/app-debug.apk`. A assinatura de debug é de desenvolvimento; publicação em loja exige assinatura própria.

Para usar Firebase local no Android Emulator, o computador host é `10.0.2.2`:

```powershell
./scripts/flutter.ps1 run -d ID_DO_ANDROID --dart-define-from-file=config/emulators.json --dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2
```

Em celular USB, `adb reverse tcp:9099 tcp:9099` e `adb reverse tcp:9000 tcp:9000` permitem usar o host padrão 127.0.0.1, sem expor o banco à rede local.

## Testes

```powershell
./scripts/flutter.ps1 analyze
./scripts/flutter.ps1 test
pnpm run test:rules
```

`test:rules` inicia emuladores próprios nas portas 9000/9099. Encerre os emuladores de demonstração antes de executá-lo. Os testes limpam somente o projeto local demo-foco-tarefas; não use contra produção.

Testes Flutter: serialização do model, persistência do tema, validação/cadastro/edição do formulário e filtros da ListView. Testes das regras: CRUD do proprietário, bloqueio entre contas, bloqueio anônimo e payload inválido. Consulte [a validação](docs/VALIDACAO.md) para os resultados.

## Organização e entrega

```text
lib/main.dart             inicialização e sessão
lib/models/               Usuario e Tarefa
lib/screens/              autenticação, início, tarefas, detalhes, configurações
lib/services/             Auth, Realtime Database, SharedPreferences
lib/themes/               ThemeData claro/escuro
lib/widgets/              Drawer e cards
config/                   exemplo da nuvem e emuladores
test/                     testes Flutter
tests/                    testes das regras Firebase
docs/capturas/            capturas da execução real
docs/ROTEIRO_VIDEO.md      sequência para você gravar
```

O [roteiro](docs/ROTEIRO_VIDEO.md) cobre os oito itens obrigatórios do vídeo do item 7 do PDF. **Nenhum vídeo foi produzido.** Antes de enviar o link do repositório privado, assegure acesso ao professor.

Referências: [Flutter no VS Code](https://docs.flutter.dev/tools/vs-code), [Firebase para Flutter](https://firebase.google.com/docs/flutter/setup), [Realtime Database](https://firebase.google.com/docs/database/flutter/start), [emuladores](https://firebase.google.com/docs/emulator-suite/connect_rtdb).
