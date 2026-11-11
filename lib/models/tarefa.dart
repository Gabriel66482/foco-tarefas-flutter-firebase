enum Prioridade {
  baixa('Baixa'),
  media('Média'),
  alta('Alta');

  const Prioridade(this.label);
  final String label;
}

class Tarefa {
  const Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    required this.prioridade,
    required this.concluida,
  });
  final String id;
  final String titulo;
  final String descricao;
  final DateTime dataVencimento;
  final Prioridade prioridade;
  final bool concluida;

  Map<String, Object> toMap() => {
    'titulo': titulo,
    'descricao': descricao,
    'dataVencimento': dataVencimento.toIso8601String().substring(0, 10),
    'prioridade': prioridade.name,
    'concluida': concluida,
  };

  factory Tarefa.fromMap(String id, Map<Object?, Object?> data) => Tarefa(
    id: id,
    titulo: data['titulo'] as String,
    descricao: data['descricao'] as String,
    dataVencimento: DateTime.parse(data['dataVencimento'] as String),
    prioridade: Prioridade.values.byName(data['prioridade'] as String),
    concluida: data['concluida'] as bool,
  );

  Tarefa comSituacao(bool valor) => Tarefa(
    id: id,
    titulo: titulo,
    descricao: descricao,
    dataVencimento: dataVencimento,
    prioridade: prioridade,
    concluida: valor,
  );

  bool get atrasada {
    final hoje = DateTime.now();
    return !concluida &&
        dataVencimento.isBefore(DateTime(hoje.year, hoje.month, hoje.day));
  }
}
