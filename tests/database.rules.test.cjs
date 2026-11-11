const { test, before, after, beforeEach } = require('node:test');
const { readFileSync } = require('node:fs');
const { initializeTestEnvironment, assertSucceeds, assertFails } = require('@firebase/rules-unit-testing');
const { ref, set, get, update, remove } = require('firebase/database');
let environment;
const tarefa = { titulo: 'Estudar Flutter', descricao: 'Revisar models',
  dataVencimento: '2026-12-10', prioridade: 'alta', concluida: false };
before(async () => {
  environment = await initializeTestEnvironment({ projectId: 'demo-foco-tarefas',
    database: { host: '127.0.0.1', port: 9000,
      rules: readFileSync('database.rules.json', 'utf8') } });
});
beforeEach(async () => { await environment.clearDatabase(); });
after(async () => { await environment?.cleanup(); });

test('Proprietário pode criar, consultar, editar, concluir e excluir', async () => {
  const db = environment.authenticatedContext('alice').database();
  const item = ref(db, 'usuarios/alice/tarefas/t1');
  await assertSucceeds(set(item, tarefa));
  await assertSucceeds(get(item));
  await assertSucceeds(update(item, { titulo: 'Flutter revisado', concluida: true }));
  const snapshot = await get(item);
  if (snapshot.val().concluida !== true) throw new Error('Situação não persistida');
  await assertSucceeds(remove(item));
});

test('Outra conta não pode ler nem alterar tarefas do proprietário', async () => {
  const alice = environment.authenticatedContext('alice').database();
  await set(ref(alice, 'usuarios/alice/tarefas/t1'), tarefa);
  const bob = environment.authenticatedContext('bob').database();
  const item = ref(bob, 'usuarios/alice/tarefas/t1');
  await assertFails(get(item));
  await assertFails(set(item, tarefa));
  await assertFails(update(item, { concluida: true }));
  await assertFails(remove(item));
  await assertFails(get(ref(bob, 'usuarios')));
});

test('Sem autenticação não é possível ler nem gravar', async () => {
  const db = environment.unauthenticatedContext().database();
  await assertFails(get(ref(db, 'usuarios/alice/tarefas')));
  await assertFails(set(ref(db, 'usuarios/alice/tarefas/t1'), tarefa));
});

test('Validação rejeita payload incompleto, prioridade, tipo e campos inválidos', async () => {
  const db = environment.authenticatedContext('alice').database();
  const item = ref(db, 'usuarios/alice/tarefas/t1');
  await assertFails(set(item, { titulo: 'Sem dados' }));
  await assertFails(set(item, { ...tarefa, prioridade: 'urgente' }));
  await assertFails(set(item, { ...tarefa, concluida: 'sim' }));
  await assertFails(set(item, { ...tarefa, titulo: '' }));
  await assertFails(set(item, { ...tarefa, dataVencimento: 'amanhã' }));
  await assertFails(set(item, { ...tarefa, admin: true }));
});
