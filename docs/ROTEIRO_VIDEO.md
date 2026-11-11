# Roteiro para você gravar - Foco / P2

Este roteiro cobre os oito itens obrigatórios do item 7 do PDF. Nenhum vídeo foi produzido. O PDF não fixa duração; aproximadamente 6 a 9 minutos é apenas uma sugestão.

## Preparação

- Use a configuração **Firebase na nuvem**, conforme README. Os emuladores servem para ensaiar, mas não demonstram armazenamento na nuvem.
- Deixe o projeto aberto no VS Code e o aplicativo em um Android conectado ou Android Emulator. A versão web serve para ensaio; confirme com o professor se ele aceita demonstração no navegador.
- Abra o console Firebase em Authentication e Realtime Database > Dados. Use um novo e-mail de demonstração e anote a senha sem mostrá-la no vídeo.
- Escolha vencimentos futuros em relação ao dia da gravação. Prepare duas tarefas: **Estudar Flutter**, descrição “Revisar Drawer, ListView e models”, prioridade Alta; e **Preparar entrega da P2**, descrição “Conferir README e demonstrar Firebase”, prioridade Média.
- Não exiba senhas, tokens, códigos de autorização, contas de serviço ou dados pessoais de outras contas. Não é necessário apagar dados reais para gravar.

## 1. Apresentação - 20 a 30 segundos

**Mostre:** VS Code com o projeto e aplicativo na tela de login.

**Fale:** “Olá, sou [seu nome]. Este é o Foco, meu aplicativo de gerenciamento de tarefas da P2 de Programação Mobile. Ele foi desenvolvido em Flutter e Dart, com Firebase Authentication para as contas, Realtime Database para as tarefas e SharedPreferences para a preferência de tema.”

## 2. Cadastro de usuário e login - 1 minuto

**Faça:** Criar minha conta > preencha nome, e-mail, senha e confirmação > Cadastrar. Mostre seu nome no início. Abra o Drawer, clique em Sair e faça login com o mesmo e-mail e senha.

**Fale:** “O formulário valida os dados obrigatórios. O cadastro e o login são feitos pelo Firebase Authentication. Depois do cadastro, o aplicativo mostra o nome do usuário. Vou sair e entrar com a conta criada para demonstrar o login por e-mail e senha.”

**Comprove:** atualize a lista de usuários no console Authentication e mostre a conta criada, sem expor outras contas.

## 3. Duas tarefas e ListView - 1 a 2 minutos

**Faça:** crie **Estudar Flutter** com todos os campos, prioridade Alta e situação Pendente. Salve. Crie **Preparar entrega da P2** com todos os campos, prioridade Média e situação Pendente. Abra Drawer > Minhas tarefas.

**Mostre:** as duas tarefas na ListView, seus vencimentos, prioridades e situações. Abra uma tarefa para mostrar sua descrição nos detalhes.

**Fale:** “Cada tarefa possui título, descrição, vencimento, prioridade e situação. A lista usa ListView, com ícones e cores para identificar a prioridade. Há filtros para todas, pendentes e concluídas.”

## 4. Edição e situação - 1 minuto

**Faça:** abra Estudar Flutter > Editar tarefa. Altere o título para **Estudar Flutter e Firebase**, mude a descrição ou vencimento e salve. Use Concluir tarefa. Volte ao início e mostre os contadores. Abra o filtro Concluídas. Depois mostre Marcar como pendente para comprovar a mudança no sentido inverso.

**Fale:** “A edição preserva o ID da tarefa e atualiza o registro no Firebase. A situação pode mudar de pendente para concluída e voltar. Os contadores e a lista acompanham as alterações em tempo real.”

## 5. Realtime Database e exclusão - 1 a 2 minutos

**Faça:** mostre no console Realtime Database > Dados o caminho `usuarios/{uid}/tarefas`. Compare o UID com a conta no Authentication. Expanda as duas tarefas e mostre título, descrição, dataVencimento, prioridade e concluida.

**Fale:** “Cada conjunto de tarefas fica associado ao UID do usuário autenticado. O serviço usa o listener onValue do Realtime Database. As regras só permitem acesso quando o UID da sessão corresponde ao caminho dos dados.”

**Faça:** no app, abra **Preparar entrega da P2**, clique em Excluir tarefa e confirme. Mostre que ela desapareceu da lista e do banco. Mantenha a outra tarefa para a etapa seguinte.

**Fale:** “A exclusão solicita confirmação. Depois disso, o registro é removido do banco e a lista é atualizada. A outra tarefa continua salva.”

**Opcional:** abra uma segunda sessão na mesma conta e mostre a atualização simultânea. Não altere dados manualmente no console para simular ações que deveriam ocorrer pelo app.

## 6. Logout e novo login - 30 a 45 segundos

**Faça:** Drawer > Sair. Entre novamente com a mesma conta. Mostre a tarefa mantida, com o título editado.

**Fale:** “Depois de sair e entrar novamente, o aplicativo recupera as tarefas desta conta, armazenadas no Firebase.”

## 7. Tema escuro e reabertura - 45 a 60 segundos

**Faça:** Drawer > Configurações > Tema escuro. Navegue entre início, lista e detalhes. Feche e reabra o aplicativo **sem fazer logout**. No Android, encerre o app e abra novamente. No navegador de ensaio, reabra a mesma URL, porta e perfil; não use aba anônima.

**Mostre:** tema escuro continua aplicado e sessão continua autenticada. Para demonstrar o tema na autenticação, faça logout somente depois dessa verificação e mostre a tela de login escura.

**Fale:** “SharedPreferences salva a escolha do tema e a recupera ao iniciar. ThemeMode seleciona os ThemeData claro e escuro para todo o aplicativo. A sessão é mantida pelo Firebase ao reabrir sem logout.”

## 8. Código e encerramento - 30 a 45 segundos

**Mostre no VS Code:** models/usuario.dart, models/tarefa.dart, services/auth_service.dart, services/firebase_service.dart, services/preferences_service.dart, themes/app_theme.dart e widgets/drawer_menu.dart. Mostre brevemente o README, as capturas e o repositório.

**Fale:** “O código está separado em models, serviços, telas, widgets e temas. O model Tarefa é usado nas operações de cadastro, consulta, edição e exclusão. O projeto inclui instruções de configuração, testes e regras de acesso por usuário. O código completo está no repositório informado na entrega.”

## Conferência da gravação

| Obrigação do PDF | Etapa |
|---|---|
| 1. Cadastro de usuário | 2 |
| 2. Login com e-mail e senha | 2 |
| 3. Pelo menos duas tarefas | 3 |
| 4. Edição e exclusão | 4 e 5 |
| 5. ListView | 3 |
| 6. Logout e login novamente | 6 |
| 7. Tema escuro e reabertura | 7 |
| 8. Dados no Realtime Database | 5 |

Confira áudio compreensível, textos legíveis e acesso do professor ao repositório privado. Use as falas como apoio e explique as ações com suas próprias palavras.
