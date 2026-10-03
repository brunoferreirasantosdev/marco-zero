enum PerfilId { organizacao, endividado, investidor, projetos, aposentadoria }

enum EtapaPerguntas { acolhimento, experiencia, especificas }

class Pergunta {
  const Pergunta(this.id, this.texto);

  final String id;
  final String texto;
}

class PerfilRoteiro {
  const PerfilRoteiro({
    required this.id,
    required this.titulo,
    required this.sinais,
    required this.palavras,
    required this.acolhimento,
    required this.experiencia,
    required this.especificas,
  });

  final PerfilId id;
  final String titulo;
  final String sinais;
  final List<String> palavras;
  final List<Pergunta> acolhimento;
  final List<Pergunta> experiencia;
  final List<Pergunta> especificas;

  List<Pergunta> daEtapa(EtapaPerguntas etapa) {
    return switch (etapa) {
      EtapaPerguntas.acolhimento => acolhimento,
      EtapaPerguntas.experiencia => experiencia,
      EtapaPerguntas.especificas => especificas,
    };
  }
}

const perguntaChave =
    'Qual a sua expectativa em relação ao trabalho ou resultado que você espera ao final deste atendimento?';

const ligamentoExpectativa =
    'Bom, fico feliz que você tenha encontrado a gente, porque você está no melhor lugar. A gente trabalha diariamente com esse tipo de cenário. Então, durante o trabalho que vamos fazer juntos aqui, [ Nome do cliente ], dentro da metodologia financeira que vamos aplicar, nós vamos ter encontros para falar sobre organização financeira e projeção futura. Inclusive, eu atuo na Grão, que é a maior empresa de planejamento financeiro do país. É uma empresa que já teve a oportunidade de ajudar mais de 8 mil famílias em casos exatamente iguais a esse que você trouxe aqui, e temos ferramentas e metodologia para auxiliar na condução desse trabalho que vamos fazer aqui juntos.';

const perguntasPadraoExpectativa = <Pergunta>[
  Pergunta(
    'padrao.expectativa.01',
    'O que motivou a procurar o planejador financeiro?',
  ),
];

const perguntasPadraoAcolhimento = <Pergunta>[
  Pergunta('padrao.acolhimento.01', 'Hoje, o que incomoda você nas suas finanças pessoais?'),
  Pergunta('padrao.acolhimento.02', 'Qual sua sensação no final do mês em relação ao seu dinheiro?'),
  Pergunta(
    'padrao.acolhimento.03',
    'Qual o seu sentimento ao olhar para sua conta bancária ou fatura do cartão de crédito?',
  ),
  Pergunta('padrao.acolhimento.04', 'Como você avalia o seu relacionamento com o dinheiro?'),
  Pergunta('padrao.acolhimento.05', 'Como você se sentiria se conseguisse ter uma sobra financeira mensal?'),
  Pergunta(
    'padrao.acolhimento.06',
    'Sobrando dinheiro no final do mês, qual o primeiro pensamento que vem à cabeça?',
  ),
];

const perguntasPadraoExperiencia = <Pergunta>[
  Pergunta(
    'padrao.experiencia.01',
    'Refletindo sobre a sua sensação e o que te incomoda, como é para você olhar para seus números, seu orçamento em busca de melhorias?',
  ),
  Pergunta(
    'padrao.experiencia.02',
    'Você tem o costume de parar e olhar as entradas e saídas dos seus extratos bancários e faturas de cartão de crédito ao longo do mês?',
  ),
  Pergunta(
    'padrao.experiencia.03',
    'Se você tem este costume, como você faz isso? Sozinho ou tem ajuda de alguém?',
  ),
  Pergunta(
    'padrao.experiencia.04',
    'O que você diria que é sua maior dificuldade para organizar o orçamento? (falta de tempo, motivação/prioridade, esquecimento)',
  ),
  Pergunta('padrao.experiencia.05', 'Esse assunto de finanças pessoais é conversado ou abordado em sua família?'),
];

const perguntasPadraoEspecificas = <Pergunta>[
  Pergunta(
    'padrao.especificas.01',
    'Tendo em vista que você veio buscar ajuda para melhorar seu orçamento, o quanto você avalia importante e necessário olhar para suas receitas e despesas durante o mês?',
  ),
  Pergunta('padrao.especificas.02', 'Você já refletiu sobre onde está indo o dinheiro?'),
  Pergunta('padrao.especificas.03', 'Tem alguma despesa que você suspeita que esteja causando esse problema mensal?'),
  Pergunta('padrao.especificas.04', 'Quais hábitos do seu dia a dia que fazem você feliz?'),
  Pergunta('padrao.especificas.05', 'O que você gostaria de fazer durante o mês, mas que não está conseguindo realizar?'),
  Pergunta('padrao.especificas.06', 'Você já considerou alguma alternativa para aumentar a sua renda mensal?'),
  Pergunta('padrao.especificas.07', 'Você acredita que o seu padrão de vida pode estar acima da renda familiar mensal?'),
  Pergunta(
    'padrao.especificas.08',
    'Se for necessário, o que você estaria disposto a abrir mão no seu estilo de vida para melhorar a sua saúde financeira?',
  ),
];

const orientacaoExpectativa =
    'Storytelling, compreensão do tema a ser discutido, expectativas e o resultado esperado pelo cliente. A reunião foca um dos cinco temas.';

const orientacaoAcolhimento =
    'Acolhimento, empatia e as sensações geradas pelo tema. Aqui se mapeia a dor.';

const orientacaoExperiencia =
    'Nível de conhecimento e histórico pessoal ou familiar com o tema. Aqui se entende o problema.';

const orientacaoEspecificas =
    'Detalhes do tema, inclusive quantitativos, e a motivação real para resolvê-lo. Planos de ação desta primeira reunião ficam genéricos.';

const orientacaoConceitos =
    'O plano de ação desta etapa segue o perfil confirmado e a jornada de atendimento no Dashplan.';

const orientacaoProposta =
    'A proposta apresenta os dois planos do portfólio, com os benefícios e o valor de R\$ 300 por mês.';

String planoDeAcao(PerfilId? perfil) {
  final texto = switch (perfil) {
    PerfilId.organizacao => _planoOrganizacao,
    PerfilId.endividado => _planoEndividado,
    PerfilId.investidor => _planoInvestidor,
    PerfilId.projetos => _planoProjetos,
    PerfilId.aposentadoria => _planoAposentadoria,
    null =>
      'Confirme o perfil na etapa anterior. O plano de ação é escrito para a jornada desse perfil.',
  };
  return texto.trim();
}

String propostaComercial(PerfilId? perfil) {
  final ponte = switch (perfil) {
    PerfilId.organizacao =>
      'O plano que acabamos de ver pede um onboarding e de quatro a seis encontros de uma hora, além do suporte entre as reuniões.',
    PerfilId.endividado =>
      'O plano que acabamos de ver pede um onboarding e de seis a doze encontros de uma hora, porque a saída das dívidas leva mais tempo, além do suporte entre as reuniões.',
    PerfilId.investidor || PerfilId.projetos || PerfilId.aposentadoria =>
      'O plano que acabamos de ver pede um onboarding, a análise quando ela fizer falta e de quatro a seis encontros de uma hora, além do suporte entre as reuniões.',
    null => 'O número de encontros segue o plano de ação do perfil confirmado.',
  };
  return '''[ Nome do cliente ], o caminho que descrevi é o trabalho que fazemos juntos dentro do plano. $ponte

Há duas formas de contratar, e as duas custam R\$ 300 por mês.

No Plano Semestral, o contrato é de 6 meses, com no mínimo 6 reuniões on-line. O suporte por WhatsApp é ilimitado. O Dashplan e a Finclass ficam liberados durante o contrato.

No Plano Anual, o contrato é de 12 meses, com no mínimo 12 reuniões on-line. O suporte por WhatsApp também é ilimitado, e o Dashplan e a Finclass ficam liberados durante o contrato.

A diferença entre eles é o tempo de acompanhamento: 6 meses ou 12 meses. O valor, nos dois, é R\$ 300 por mês.''';
}

const _planoOrganizacao = '''
[ Nome do cliente ], pelo que você trouxe hoje, o trabalho daqui para a frente é organizar o orçamento e fazer o dinheiro passar a ter destino. Essa jornada acontece no Dashplan, com a minha mentoria.

No primeiro encontro, de uma hora a uma hora e meia, vemos o futuro só o necessário: a curva da aposentadoria e os projetos essenciais dos próximos dois anos, sem abrir agora o que não for a sua prioridade. Em seguida, conectamos as contas pelo Open Finance, quando isso for simples para você. Se não houver interesse ou a conexão não for viável, criamos as contas manualmente e seguimos por entrevista. Aí classificamos os lançamentos e montamos a primeira parte do plano de gastos.

No encontro seguinte, fechamos o orçamento com números próximos da sua realidade e definimos as metas. Começamos pelas despesas que não são obrigatórias, que costumam ser o maior vazamento, e medimos quanto passa a sobrar com os novos tetos.

Depois vêm de quatro a seis encontros de uma hora para colocar o plano em prática e acompanhar as metas de gasto e os aportes. Entre uma reunião e outra, as dúvidas seguem pelo WhatsApp e, quando você precisar, em uma conversa de trinta minutos. Com o orçamento de pé, avançamos para patrimônio, investimentos, proteção e a Bússola Financeira.
''';

const _planoEndividado = '''
[ Nome do cliente ], o plano é sair das dívidas com método e, só depois disso, começar a poupar. Eu sigo com você no orçamento e na revisão dos créditos, dentro do Dashplan.

No primeiro encontro, de uma hora a uma hora e meia, a curva do futuro serve para nomear o projeto de vida que você quer realizar quando o endividamento acabar, sem desviar o foco. Mapeamos todas as dívidas, os financiamentos e os saldos, e também os bens que podem entrar numa solução, como a troca ou a venda de um veículo. Conectamos as contas pelo Open Finance ou seguimos manualmente, e classificamos os lançamentos para enxergar para onde o dinheiro está indo.

No encontro seguinte, montamos o orçamento e definimos metas mais firmes de corte, começando pelo que não é obrigatório: transporte, assinaturas e o que der para reduzir sem comprometer o essencial.

São de seis a doze encontros de uma hora, porque essa saída pede mais tempo e mais presença. No caminho, avaliamos portabilidade, crédito e renegociação. Investimento e proteção entram quando a dívida tiver saído de cena e a poupança tiver começado. As dúvidas seguem pelo WhatsApp e, quando você precisar, em uma conversa de trinta minutos.
''';

const _planoInvestidor = '''
[ Nome do cliente ], o trabalho que vamos fazer é organizar a sua estratégia de investimento e conferir se ela cabe na sua vida. A jornada é no Dashplan, com a minha mentoria.

No primeiro encontro, de uma hora a uma hora e meia, desenhamos a curva da aposentadoria e listamos os projetos dos próximos seis anos, porque isso define a alocação e a ordem das prioridades. Mapeamos imóveis, bens, dívidas e o que gera renda. Montamos a divisão entre reserva de emergência, projetos e aposentadoria. A reserva pode começar em seis meses de despesas. Definimos a meta de aporte e vemos se esse valor já cabe no mês. Se ainda não couber, o caminho passa primeiro pela organização do orçamento.

Quando fizer falta, um encontro seguinte organiza contas, lançamentos e o plano de gastos. Na implementação, ajustamos os investimentos. No acompanhamento, de quatro a seis encontros de uma hora, olhamos as metas e a proteção. Se o tema pedir um especialista, indico um consultor de investimentos e um corretor de proteção e seguros. As dúvidas seguem pelo WhatsApp e, quando você precisar, em uma conversa de trinta minutos. A Bússola Financeira mostra a evolução ao longo do contrato.
''';

const _planoProjetos = '''
[ Nome do cliente ], o plano é tirar o seu projeto do desejo e colocá-lo numa data e num valor que caibam no seu mês. Fazemos isso no Dashplan, com a minha mentoria.

No primeiro encontro, de uma hora a uma hora e meia, desenhamos a curva da aposentadoria e detalhamos o projeto: o que é, para quando, quanto custa e quem mais ele envolve. Listamos os outros planos que podem competir com ele nos próximos seis anos. Mapeamos patrimônio e dívidas, porque o projeto precisa caber no que você já tem. Se o aporte mensal ainda não existir, o caminho passa pela organização do orçamento antes de acelerar a realização.

Quando fizer falta, o encontro seguinte organiza contas, lançamentos e o plano de gastos, e define quanto do mês fica reservado para o projeto. São de quatro a seis encontros de uma hora para acompanhar a meta e ajustar o ritmo. Proteção e investimentos entram para sustentar o projeto, não para desviá-lo. As dúvidas seguem pelo WhatsApp e, quando você precisar, em uma conversa de trinta minutos.
''';

const _planoAposentadoria = '''
[ Nome do cliente ], o trabalho é calcular a independência financeira e transformar essa conta num aporte que caiba na sua vida. A jornada acontece no Dashplan, com a minha mentoria.

No primeiro encontro, de uma hora a uma hora e meia, desenhamos a curva da aposentadoria e o padrão de vida que você quer proteger: moradia, renda e quem mais depende desse dinheiro. Mapeamos o que já existe hoje, como previdência, aluguéis, pensão ou INSS, e o patrimônio que entra nessa conta. Definimos a reserva de emergência e a meta de investimento mensal. Se esse valor ainda não couber no mês, organizamos o orçamento antes de aumentar o aporte.

Quando fizer falta, um encontro seguinte passa por contas, lançamentos e plano de gastos. Na implementação, ajustamos os investimentos da aposentadoria. No acompanhamento, de quatro a seis encontros de uma hora, vemos se a meta está sendo cumprida e tratamos da proteção dessa renda. Se precisar, indico um consultor de investimentos e um corretor de proteção. As dúvidas seguem pelo WhatsApp e, quando você precisar, em uma conversa de trinta minutos. A Bússola Financeira acompanha a evolução ao longo do contrato.
''';

const roteiro = <PerfilRoteiro>[
  PerfilRoteiro(
    id: PerfilId.organizacao,
    titulo: 'Organização orçamentária',
    sinais:
        'Organização financeira, para onde o dinheiro vai todo mês, fazer sobrar dinheiro, controlar gastos, elaborar orçamento.',
    palavras: [
      'orcamento',
      'gastos',
      'sobrar',
      'controlar gastos',
      'organizacao financeira',
      'superfluo',
      'onde o dinheiro',
    ],
    acolhimento: [
      Pergunta(
        'organizacao.acolhimento.01',
        'Tem algo que te incomoda em suas finanças pessoais?',
      ),
      Pergunta(
        'organizacao.acolhimento.02',
        'Qual a sua sensação no final do mês em relação ao seu dinheiro?',
      ),
      Pergunta(
        'organizacao.acolhimento.03',
        'Qual o seu sentimento ao olhar para sua conta bancária ou fatura do cartão de crédito?',
      ),
      Pergunta(
        'organizacao.acolhimento.04',
        'Como você avalia o seu relacionamento com o dinheiro?',
      ),
      Pergunta(
        'organizacao.acolhimento.05',
        'Como você se sentiria se conseguisse ter uma sobra financeira mensal?',
      ),
      Pergunta(
        'organizacao.acolhimento.06',
        'Sobrando dinheiro no final do mês, qual o primeiro pensamento que te vem à cabeça? O que você gostaria de fazer?',
      ),
    ],
    experiencia: [
      Pergunta(
        'organizacao.experiencia.01',
        'Refletindo sobre a sua sensação e o que te incomoda, você já tentou olhar para seus números, para o orçamento em busca de melhorias?',
      ),
      Pergunta(
        'organizacao.experiencia.02',
        'Você tem o costume de parar e olhar as entradas e saídas dos seus extratos bancários e faturas de cartão de crédito ao longo do mês?',
      ),
      Pergunta(
        'organizacao.experiencia.03',
        'Se você tem este costume, como você faz isso? Sozinho(a) ou tem ajuda de alguém?',
      ),
      Pergunta(
        'organizacao.experiencia.04',
        'Você conhece o conceito de despesa obrigatória e não obrigatória?',
      ),
      Pergunta(
        'organizacao.experiencia.05',
        'O que você diria que é sua maior dificuldade para organizar o orçamento? (Falta de tempo, motivação/prioridade, esquecimento, conhecimento...).',
      ),
      Pergunta(
        'organizacao.experiencia.06',
        'Esse assunto de finanças pessoais é conversado ou abordado em sua família?',
      ),
    ],
    especificas: [
      Pergunta(
        'organizacao.especificas.01',
        'Tendo em vista hoje você buscar ajuda para melhorar o orçamento, o quanto você avalia importante e necessário, neste momento, olhar para suas receitas e despesas durante o mês?',
      ),
      Pergunta(
        'organizacao.especificas.02',
        'Você já refletiu sobre onde está indo o dinheiro?',
      ),
      Pergunta(
        'organizacao.especificas.03',
        'Tem alguma despesa que você suspeita que esteja causando esse problema mensal?',
      ),
      Pergunta(
        'organizacao.especificas.04',
        'Quais hábitos do seu dia a dia te fazem feliz?',
      ),
      Pergunta(
        'organizacao.especificas.05',
        'O que você gostaria de fazer durante o mês, mas que não está conseguindo realizar?',
      ),
      Pergunta(
        'organizacao.especificas.06',
        'Você já considerou alguma alternativa para aumentar a sua renda?',
      ),
      Pergunta(
        'organizacao.especificas.07',
        'Você acredita que o seu padrão de vida pode estar acima da renda familiar mensal?',
      ),
      Pergunta(
        'organizacao.especificas.08',
        'Se for necessário, o que você estaria disposto a abrir mão no seu estilo de vida para melhorar a sua saúde financeira?',
      ),
    ],
  ),
  PerfilRoteiro(
    id: PerfilId.endividado,
    titulo: 'Endividado',
    sinais:
        'Quitar dívidas, reduzir taxa de juros, reduzir juros dos financiamentos, reduzir o valor das parcelas, zerar o cartão de crédito.',
    palavras: [
      'divida',
      'endivid',
      'juros',
      'parcela',
      'cartao',
      'financiamento',
      'emprestimo',
      'quitar',
    ],
    acolhimento: [
      Pergunta(
        'endividado.acolhimento.01',
        'Por favor, poderia compartilhar comigo como está a sua situação financeira atual?',
      ),
      Pergunta(
        'endividado.acolhimento.02',
        'Poderia me dizer como você adquiriu esse endividamento? Por exemplo, perda inesperada de renda ou algum outro tipo de imprevisto?',
      ),
      Pergunta(
        'endividado.acolhimento.03',
        'Como você descreveria a ordem dos acontecimentos até chegar na situação atual?',
      ),
      Pergunta(
        'endividado.acolhimento.04',
        'Você já refletiu sobre essa situação? Como se sente?',
      ),
      Pergunta(
        'endividado.acolhimento.05',
        'Qual foi a sua sensação ao tomar essa dívida?',
      ),
      Pergunta(
        'endividado.acolhimento.06',
        'Qual foi o maior impacto dessa dívida na sua vida? Existe uma tensão familiar em relação a isso?',
      ),
    ],
    experiencia: [
      Pergunta(
        'endividado.experiencia.01',
        'Você já esteve nessa situação antes? Se sim, como foi e de que maneira contornou a situação?',
      ),
      Pergunta(
        'endividado.experiencia.02',
        'Por favor, poderia me dizer como foi a escolha desse empréstimo ou financiamento? Você fez tudo sozinho ou teve a ajuda de alguém ou de alguma instituição financeira?',
      ),
      Pergunta(
        'endividado.experiencia.03',
        'Você considerou outras alternativas antes de pegar o empréstimo (exemplo: renda extra, venda de itens que não utiliza etc.)?',
      ),
      Pergunta(
        'endividado.experiencia.04',
        'Você se avalia como uma pessoa mais impulsiva ou mais controlada em sua relação com o dinheiro?',
      ),
      Pergunta(
        'endividado.experiencia.05',
        'Você crê que gasta mais do que deveria ou poderia? Se sim, com que frequência isso ocorre?',
      ),
      Pergunta(
        'endividado.experiencia.06',
        'Você conhece o conceito de despesa obrigatória e não obrigatória? Daqui a pouco lhe apresentarei como funciona na prática.',
      ),
    ],
    especificas: [
      Pergunta(
        'endividado.especificas.01',
        'Essa dívida impacta somente você ou tem mais pessoas envolvidas (amigos, parentes, pessoas próximas etc.)?',
      ),
      Pergunta(
        'endividado.especificas.02',
        'Na prática, como vocês lidam com as finanças pessoais em sua família após tomar esta dívida? Tiveram que fazer alguma modificação ou deixar de fazer algo que gostavam?',
      ),
      Pergunta(
        'endividado.especificas.03',
        'Em quanto tempo você gostaria de quitar essa dívida e encerrar essa situação?',
      ),
      Pergunta(
        'endividado.especificas.04',
        'Você já tentou alguma vez renegociar de alguma forma esta dívida?',
      ),
      Pergunta(
        'endividado.especificas.05',
        'De zero a dez, quanto seria o seu nível de comprometimento com você e a sua família para sair e resolver essa situação?',
      ),
      Pergunta(
        'endividado.especificas.06',
        'Qual o maior desejo ou plano seu e de sua família que querem realizar após eu ajudar você a quitar as dívidas e sair desta situação?',
      ),
      Pergunta(
        'endividado.especificas.07',
        'Você está disposto a mudar os hábitos que te levaram a essa situação?',
      ),
    ],
  ),
  PerfilRoteiro(
    id: PerfilId.investidor,
    titulo: 'Investidor',
    sinais:
        'Fazer reserva de emergência, alocar melhor a carteira, revisar investimentos, melhorar rendimentos, sair do banco.',
    palavras: [
      'investir',
      'investimento',
      'carteira',
      'rendimento',
      'reserva de emergencia',
      'corretora',
      'sair do banco',
    ],
    acolhimento: [
      Pergunta(
        'investidor.acolhimento.01',
        'Poderia me dizer qual a sua maior expectativa ao investir?',
      ),
      Pergunta(
        'investidor.acolhimento.02',
        'Como você se sente ao pensar em investir no mercado financeiro?',
      ),
      Pergunta(
        'investidor.acolhimento.03',
        'Qual sua maior dificuldade quando pensa em investimentos (falta de tempo, conhecimento, gosto pelo tema, oportunidade etc.)?',
      ),
      Pergunta(
        'investidor.acolhimento.04',
        'Quais são os seus maiores receios ao investir no mercado financeiro?',
      ),
      Pergunta(
        'investidor.acolhimento.05',
        'Você se espelha ou usa alguém como referência em relação a investimentos (amigo, familiar, influencer)?',
      ),
      Pergunta(
        'investidor.acolhimento.06',
        'Você decide sozinho(a) ou mais alguém está envolvido na decisão destes investimentos?',
      ),
    ],
    experiencia: [
      Pergunta(
        'investidor.experiencia.01',
        'Com quais tipos de investimentos você já teve contato e experiência?',
      ),
      Pergunta(
        'investidor.experiencia.02',
        'Com quais instituições financeiras (bancos, corretoras, fintechs) você já teve contato?',
      ),
      Pergunta(
        'investidor.experiencia.03',
        'Como foi toda esta experiência para você e sua família?',
      ),
      Pergunta(
        'investidor.experiencia.04',
        'Qual foi a sua maior alegria e a sua maior frustração com investimentos?',
      ),
      Pergunta(
        'investidor.experiencia.05',
        'Você se informa sobre o mercado de investimentos? Se sim, quais suas fontes de informação preferidas?',
      ),
      Pergunta(
        'investidor.experiencia.06',
        'Alguém já lhe auxiliou antes com estratégias de investimento? Se positivo, como foi esta experiência para você?',
      ),
    ],
    especificas: [
      Pergunta(
        'investidor.especificas.01',
        'Quais os principais objetivos que gostaria de alcançar através dos investimentos?',
      ),
      Pergunta(
        'investidor.especificas.02',
        'Você acredita que possui uma reserva de emergência suficiente para você e sua família, em caso de imprevistos?',
      ),
      Pergunta(
        'investidor.especificas.03',
        'Quando você pensa em investimento, você pensa em algo para ser feito recorrentemente (por exemplo, mensalmente) ou de tempos em tempos?',
      ),
      Pergunta(
        'investidor.especificas.04',
        'Quais são seus principais projetos de vida para os próximos 2 anos?',
      ),
      Pergunta(
        'investidor.especificas.05',
        'Você gostaria de ter ajuda especializada para decidir e acompanhar seus investimentos?',
      ),
      Pergunta(
        'investidor.especificas.06',
        'Você conhece o papel de cada profissional e especialista do mercado financeiro?',
      ),
      Pergunta(
        'investidor.especificas.07',
        'Você gostaria de aprender e ser mais participativo nas decisões sobre investimentos ou prefere delegar a um especialista de sua confiança?',
      ),
      Pergunta(
        'investidor.especificas.08',
        'O quão comprometido você está em investir periodicamente para alcançar os seus objetivos?',
      ),
    ],
  ),
  PerfilRoteiro(
    id: PerfilId.projetos,
    titulo: 'Projetos',
    sinais:
        'Viagens, comprar ou alugar casa, troca de carro, ter filho, cursos, reforma da casa, transição de carreira, montar o próprio negócio.',
    palavras: [
      'viagem',
      'alugar',
      'carro',
      'filho',
      'curso',
      'reforma',
      'carreira',
      'negocio',
      'comprar casa',
      'casa propria',
    ],
    acolhimento: [
      Pergunta(
        'projetos.acolhimento.01',
        'Poderia me contar um pouco mais sobre o seu projeto? Já tem clareza dele ou é apenas uma ideia inicial?',
      ),
      Pergunta(
        'projetos.acolhimento.02',
        'Quando foi que decidiu realizar este projeto? Decidiu sozinho ou mais alguém participou desta decisão?',
      ),
      Pergunta(
        'projetos.acolhimento.03',
        'Qual a importância desse projeto para você?',
      ),
      Pergunta(
        'projetos.acolhimento.04',
        'Esse projeto também impacta e tem importância para outras pessoas além de você?',
      ),
      Pergunta(
        'projetos.acolhimento.05',
        'Existe algum outro projeto para você e sua família mais importante que este?',
      ),
      Pergunta(
        'projetos.acolhimento.06',
        'Existem outros projetos que gostaria de realizar e que podem competir com este?',
      ),
    ],
    experiencia: [
      Pergunta(
        'projetos.experiencia.01',
        'Você já tem clareza de quando quer realizar esse projeto?',
      ),
      Pergunta(
        'projetos.experiencia.02',
        'Quanto você imagina gastar com este projeto? São valores precisos ou apenas estimativas iniciais?',
      ),
      Pergunta(
        'projetos.experiencia.03',
        'Você já discutiu com alguém ou pediu ajuda para realizar este projeto? Se sim, com quem já conversou?',
      ),
      Pergunta(
        'projetos.experiencia.04',
        'Você chegou a estudar a viabilidade deste projeto dentro do seu fluxo de caixa ou nível patrimonial atual?',
      ),
      Pergunta(
        'projetos.experiencia.05',
        'Já realizou ou conhece alguém que realizou um projeto parecido com o seu? Se positivo, como foi a experiência?',
      ),
      Pergunta(
        'projetos.experiencia.06',
        'Caso aconteça algum imprevisto ou este projeto não seja mais viável, você considera alguma alternativa ou plano B para ele?',
      ),
      Pergunta(
        'projetos.experiencia.07',
        'Você classifica como fácil, médio ou difícil o desafio de realizar este projeto? Por quê?',
      ),
    ],
    especificas: [
      Pergunta(
        'projetos.especificas.01',
        'O que estaria disposto a mudar nos seus hábitos de consumo para viabilizar ou acelerar a realização deste projeto?',
      ),
      Pergunta(
        'projetos.especificas.02',
        'Qual seria o impacto negativo para você e sua família se não conseguir realizar este projeto?',
      ),
      Pergunta(
        'projetos.especificas.03',
        'Como você acredita que se sentirá ao realizar este projeto?',
      ),
      Pergunta(
        'projetos.especificas.04',
        'Quais os benefícios práticos que este projeto proporcionará a você e sua família?',
      ),
      Pergunta(
        'projetos.especificas.05',
        'Este projeto você prefere realizar à vista ou a prazo? Por quê?',
      ),
      Pergunta(
        'projetos.especificas.06',
        'Você acredita que este projeto é compatível com seu momento financeiro atual? Por quê?',
      ),
    ],
  ),
  PerfilRoteiro(
    id: PerfilId.aposentadoria,
    titulo: 'Aposentadoria',
    sinais:
        'Quanto acumular para a independência financeira, manutenção da qualidade de vida, preocupações com o futuro, previdência para aposentadoria.',
    palavras: [
      'aposentad',
      'previdenc',
      'independencia financeira',
      'inss',
    ],
    acolhimento: [
      Pergunta(
        'aposentadoria.acolhimento.01',
        'O que você entende por aposentadoria?',
      ),
      Pergunta(
        'aposentadoria.acolhimento.02',
        'Que tipo de sentimento emerge em você quando fala sobre a sua aposentadoria?',
      ),
      Pergunta(
        'aposentadoria.acolhimento.03',
        'Como você se sente com relação ao seu futuro? (Ansioso? Acha que vai dar? Tranquilo? Com medo? Não sabe).',
      ),
      Pergunta(
        'aposentadoria.acolhimento.04',
        'Quem você gostaria de proteger com a sua renda mensal da aposentadoria, além de você?',
      ),
      Pergunta(
        'aposentadoria.acolhimento.05',
        'Você já imaginou qual impacto suas atitudes com relação às suas finanças terão na sua aposentadoria?',
      ),
    ],
    experiencia: [
      Pergunta(
        'aposentadoria.experiencia.01',
        'Na sua família já existe outra fonte de renda destinada para aposentadoria? (Aluguéis, cônjuge, herança, pensão, INSS etc.).',
      ),
      Pergunta(
        'aposentadoria.experiencia.02',
        'O que você acredita que irá garantir a sua aposentadoria? Previdência pública ou privada?',
      ),
      Pergunta(
        'aposentadoria.experiencia.03',
        'Quais são os exemplos de amigos e familiares que estão nesta fase de vida?',
      ),
      Pergunta(
        'aposentadoria.experiencia.04',
        'Você conhece alguém que já alcançou uma aposentadoria plena/satisfatória?',
      ),
      Pergunta(
        'aposentadoria.experiencia.05',
        'Você já discutiu com algum especialista sobre como se calcula o valor de poupança mensal necessário para sua aposentadoria?',
      ),
    ],
    especificas: [
      Pergunta(
        'aposentadoria.especificas.01',
        'Como você se imagina nessa fase da vida? (Onde vai morar, terá casa de veraneio, vai ter carros, renda ideal, algum hobby).',
      ),
      Pergunta(
        'aposentadoria.especificas.02',
        'Quão confortável você se sente com relação à sua previdência (pública e/ou privada) e ao seu acúmulo patrimonial para se aposentar?',
      ),
      Pergunta(
        'aposentadoria.especificas.03',
        'Como você enxerga sua atuação profissional depois que atingir a independência financeira?',
      ),
      Pergunta(
        'aposentadoria.especificas.04',
        'Você gostaria de ter ajuda especializada para decidir e acompanhar os investimentos para sua aposentadoria?',
      ),
      Pergunta(
        'aposentadoria.especificas.05',
        'Você conhece o papel de cada profissional e especialista do mercado financeiro?',
      ),
      Pergunta(
        'aposentadoria.especificas.06',
        'Você gostaria de aprender e ser mais participativo nas decisões sobre investimentos ou prefere delegar a um especialista de sua confiança?',
      ),
      Pergunta(
        'aposentadoria.especificas.07',
        'O quão comprometido você está em investir para alcançar a sua independência financeira?',
      ),
    ],
  ),
];

PerfilRoteiro perfilPorId(PerfilId id) {
  return roteiro.firstWhere((perfil) => perfil.id == id);
}

PerfilRoteiro? perfilPorNome(String? nome) {
  if (nome == null || nome.isEmpty) return null;
  for (final perfil in roteiro) {
    if (perfil.id.name == nome) return perfil;
  }
  return null;
}
