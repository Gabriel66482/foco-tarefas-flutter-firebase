# Validação da entrega

Registro das verificações efetuadas em 11/11/2026. Este arquivo será atualizado ao concluir a configuração da nuvem.

| Verificação | Resultado |
|---|---|
| flutter analyze | Sem problemas encontrados |
| flutter test | 6 testes passaram: model, tema, validação, cadastro, edição, filtros |
| Regras Firebase no emulador oficial | 4 testes passaram: CRUD, isolamento, acesso anônimo, payload inválido |
| Build web release | Gerado com sucesso, incluindo recursos locais |
| Build Android debug | APK gerado com sucesso |
| Cadastro real na interface Flutter web | Executado contra Firebase Emulator Suite |
| Cadastro de tarefa, prioridade e vencimento | Executado contra Firebase Emulator Suite |
| Capturas reais | Login, cadastro de usuário e cadastro de tarefa incluídos |

Os testes de interface automatizados usam um serviço de teste para verificar formulários e filtros. Os testes das regras usam Realtime Database real emulado. Eles não substituem um teste manual em dispositivo Android nem comprovam sozinhos a configuração da nuvem.

## Critérios e implementação

| Critério | Arquivos principais |
|---|---|
| Authentication | services/auth_service.dart, screens/login_screen.dart, screens/cadastro_usuario_screen.dart |
| Drawer | widgets/drawer_menu.dart |
| Cadastro/ListView | screens/cadastro_tarefa_screen.dart, screens/tarefas_screen.dart |
| Models | models/usuario.dart, models/tarefa.dart |
| CRUD/listeners | services/firebase_service.dart, screens/detalhes_tarefa_screen.dart |
| Associação por UID | services/firebase_service.dart, database.rules.json |
| SharedPreferences | services/preferences_service.dart |
| Tema claro/escuro | themes/app_theme.dart, main.dart |

## Capturas

As imagens foram capturadas da aplicação Flutter em execução. As capturas 01 a 03 correspondem ao ambiente dos emuladores e são identificadas como tal na interface.

![Login](capturas/01-login.jpg)

![Cadastro](capturas/02-cadastro-usuario.jpg)

![Tarefa](capturas/03-cadastro-tarefa.jpg)
