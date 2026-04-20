import 'package:flutter/material.dart';

import 'main.dart';

const _conversas = [
  ConversaItem(
    nome: 'Abrigo Patas Felizes',
    descricaoCurta: 'Abrigo',
    assunto: 'Bidu • visita e documentos',
    mensagem: 'Olá! O Bidu ainda está disponível para adoção.',
    tempo: '14:20',
    online: true,
    naoLidas: 2,
    iniciais: 'AP',
    corAvatar: Color(0xFFFFF0E1),
    corDestaque: corPrimariaEscura,
    historico: [
      MensagemConversa(
        texto: 'Olá! O Bidu ainda está disponível para adoção.',
        horario: '14:20',
        enviadaPorUsuario: false,
      ),
      MensagemConversa(
        texto: 'Que bom! Posso agendar uma visita para esta semana?',
        horario: '14:23',
        enviadaPorUsuario: true,
      ),
      MensagemConversa(
        texto: 'Pode sim. Temos um horário livre na quarta à tarde.',
        horario: '14:25',
        enviadaPorUsuario: false,
      ),
    ],
  ),
  ConversaItem(
    nome: 'Associação Miados',
    descricaoCurta: 'Associação',
    assunto: 'Luna • vacinas e adaptação',
    mensagem: 'A Luna já recebeu a primeira dose da vacina.',
    tempo: 'Ontem',
    online: true,
    iniciais: 'AM',
    corAvatar: Color(0xFFEAF4FF),
    corDestaque: Color(0xFF3B82F6),
    historico: [
      MensagemConversa(
        texto: 'A Luna já recebeu a primeira dose da vacina.',
        horario: 'Ontem',
        enviadaPorUsuario: false,
      ),
      MensagemConversa(
        texto: 'Perfeito! Vocês conseguem me enviar a carteirinha depois?',
        horario: 'Ontem',
        enviadaPorUsuario: true,
      ),
      MensagemConversa(
        texto: 'Sim, deixamos tudo separado para a visita.',
        horario: 'Ontem',
        enviadaPorUsuario: false,
      ),
    ],
  ),
  ConversaItem(
    nome: 'Canil Municipal',
    descricaoCurta: 'Canil',
    assunto: 'Rex • visita de amanhã',
    mensagem: 'Pode vir visitar o Rex amanhã no período da tarde?',
    tempo: '2 dias',
    online: true,
    iniciais: 'CM',
    corAvatar: Color(0xFFFFF1F6),
    corDestaque: Color(0xFFEC4899),
    historico: [
      MensagemConversa(
        texto: 'Pode vir visitar o Rex amanhã no período da tarde?',
        horario: '2 dias',
        enviadaPorUsuario: false,
      ),
      MensagemConversa(
        texto: 'Consigo chegar por volta das 15h. Tudo bem para vocês?',
        horario: '2 dias',
        enviadaPorUsuario: true,
      ),
      MensagemConversa(
        texto:
            'Tudo certo. Quando chegar, peça na recepção pelo setor de adoção.',
        horario: '2 dias',
        enviadaPorUsuario: false,
      ),
    ],
  ),
];

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  Future<void> _abrirConversa(
    BuildContext context,
    ConversaItem conversa,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _TelaConversaPage(conversa: conversa),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tamanho = MediaQuery.sizeOf(context);
    final compacto = tamanho.width < 380 || tamanho.height < 760;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCFDFE), Color(0xFFF3F6FB)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  compacto ? 20 : 26,
                  20,
                  compacto ? 26 : 30,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(42),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F0F172A),
                      blurRadius: 26,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mensagens',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: compacto ? 28 : 32,
                              color: const Color(0xFF24324A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Conversas com abrigos e tutores',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF8A9BB6),
                              fontSize: compacto ? 16 : 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {},
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FC),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF94A3B8),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, compacto ? 148 : 164),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: compacto ? 144 : 152,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _conversas.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 18),
                        itemBuilder: (context, index) {
                          final conversa = _conversas[index];

                          return _ContatoRapido(
                            conversa: conversa,
                            onTap: () => _abrirConversa(context, conversa),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x100F172A),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(_conversas.length, (index) {
                          final conversa = _conversas[index];
                          final ultimo = index == _conversas.length - 1;

                          return Column(
                            children: [
                              _LinhaConversa(
                                conversa: conversa,
                                compacto: compacto,
                                onTap: () => _abrirConversa(context, conversa),
                              ),
                              if (!ultimo)
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFF1F5F9),
                                  indent: 18,
                                  endIndent: 18,
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContatoRapido extends StatelessWidget {
  final ConversaItem conversa;
  final VoidCallback onTap;

  const _ContatoRapido({required this.conversa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 106,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Column(
            children: [
              _AvatarConversa(
                iniciais: conversa.iniciais,
                fundo: conversa.corAvatar,
                destaque: conversa.corDestaque,
                tamanho: 102,
                online: conversa.online,
              ),
              const SizedBox(height: 10),
              Text(
                conversa.descricaoCurta,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF5C6B84),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinhaConversa extends StatelessWidget {
  final ConversaItem conversa;
  final bool compacto;
  final VoidCallback onTap;

  const _LinhaConversa({
    required this.conversa,
    required this.compacto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(34),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: compacto ? 16 : 18,
          ),
          child: Row(
            children: [
              _AvatarConversa(
                iniciais: conversa.iniciais,
                fundo: conversa.corAvatar,
                destaque: conversa.corDestaque,
                tamanho: compacto ? 72 : 78,
                online: false,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversa.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: compacto ? 18 : 20,
                        color: const Color(0xFF24324A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      conversa.mensagem,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6F7F98),
                        fontSize: compacto ? 15 : 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    conversa.tempo,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF8EA0BC),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (conversa.naoLidas > 0)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: corPrimariaEscura,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${conversa.naoLidas}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.done_all_rounded,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarConversa extends StatelessWidget {
  final String iniciais;
  final Color fundo;
  final Color destaque;
  final double tamanho;
  final bool online;

  const _AvatarConversa({
    required this.iniciais,
    required this.fundo,
    required this.destaque,
    required this.tamanho,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    final raio = tamanho * 0.28;

    return SizedBox(
      width: tamanho,
      height: tamanho,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: tamanho,
            height: tamanho,
            decoration: BoxDecoration(
              color: fundo,
              borderRadius: BorderRadius.circular(raio),
              border: Border.all(color: Colors.white, width: 2.4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 16,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Container(
              width: tamanho * 0.58,
              height: tamanho * 0.58,
              decoration: BoxDecoration(
                color: destaque.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                iniciais,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: destaque,
                  fontSize: tamanho * 0.22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          if (online)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: tamanho * 0.2,
                height: tamanho * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ConversaItem {
  final String nome;
  final String descricaoCurta;
  final String assunto;
  final String mensagem;
  final String tempo;
  final bool online;
  final int naoLidas;
  final String iniciais;
  final Color corAvatar;
  final Color corDestaque;
  final List<MensagemConversa> historico;

  const ConversaItem({
    required this.nome,
    required this.descricaoCurta,
    required this.assunto,
    required this.mensagem,
    required this.tempo,
    required this.online,
    this.naoLidas = 0,
    required this.iniciais,
    required this.corAvatar,
    required this.corDestaque,
    required this.historico,
  });
}

class MensagemConversa {
  final String texto;
  final String horario;
  final bool enviadaPorUsuario;

  const MensagemConversa({
    required this.texto,
    required this.horario,
    required this.enviadaPorUsuario,
  });
}

class _TelaConversaPage extends StatefulWidget {
  final ConversaItem conversa;

  const _TelaConversaPage({required this.conversa});

  @override
  State<_TelaConversaPage> createState() => _TelaConversaPageState();
}

class _TelaConversaPageState extends State<_TelaConversaPage> {
  final _mensagemController = TextEditingController();
  final _listaController = ScrollController();
  final _campoFocusNode = FocusNode();
  late final List<MensagemConversa> _mensagens;

  @override
  void initState() {
    super.initState();
    _mensagens = List<MensagemConversa>.of(widget.conversa.historico);
    _campoFocusNode.addListener(_aoMudarFocoDoCampo);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rolarParaFinal(animado: false);
    });
  }

  @override
  void dispose() {
    _campoFocusNode.removeListener(_aoMudarFocoDoCampo);
    _campoFocusNode.dispose();
    _listaController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

  void _aoMudarFocoDoCampo() {
    if (!_campoFocusNode.hasFocus) {
      return;
    }

    Future<void>.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) {
        return;
      }
      _rolarParaFinal();
    });
  }

  void _rolarParaFinal({bool animado = true}) {
    if (!_listaController.hasClients) {
      return;
    }

    final destino = _listaController.position.maxScrollExtent;
    if (animado) {
      _listaController.animateTo(
        destino,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    _listaController.jumpTo(destino);
  }

  void _enviarMensagem() {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty) {
      return;
    }

    setState(() {
      _mensagens.add(
        MensagemConversa(
          texto: texto,
          horario: 'Agora',
          enviadaPorUsuario: true,
        ),
      );
    });
    _mensagemController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rolarParaFinal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversa = widget.conversa;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final padding = MediaQuery.paddingOf(context);
    final tecladoVisivel = viewInsets.bottom > 0;
    final espacoInferiorComposer = tecladoVisivel
        ? viewInsets.bottom + 12
        : padding.bottom + 12;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF6F8FC),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFCF8), Color(0xFFF3F6FB)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 20, 18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF7F9FC),
                          foregroundColor: const Color(0xFF24324A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _AvatarConversa(
                        iniciais: conversa.iniciais,
                        fundo: conversa.corAvatar,
                        destaque: conversa.corDestaque,
                        tamanho: 58,
                        online: conversa.online,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversa.nome,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF24324A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              conversa.assunto,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF7B8CA6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(bottom: tecladoVisivel ? 12 : 0),
                    child: ListView.separated(
                      controller: _listaController,
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                      itemCount: _mensagens.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final mensagem = _mensagens[index];

                        return _BolhaMensagem(
                          mensagem: mensagem,
                          corDestaque: conversa.corDestaque,
                        );
                      },
                    ),
                  ),
                ),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    10,
                    16,
                    espacoInferiorComposer,
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x140F172A),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _mensagemController,
                            focusNode: _campoFocusNode,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            onTap: _rolarParaFinal,
                            onSubmitted: (_) => _enviarMensagem(),
                            decoration: const InputDecoration(
                              hintText: 'Escreva uma mensagem...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: _enviarMensagem,
                          style: FilledButton.styleFrom(
                            backgroundColor: corPrimaria,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(52, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BolhaMensagem extends StatelessWidget {
  final MensagemConversa mensagem;
  final Color corDestaque;

  const _BolhaMensagem({required this.mensagem, required this.corDestaque});

  @override
  Widget build(BuildContext context) {
    final enviadaPorUsuario = mensagem.enviadaPorUsuario;
    final corFundo = enviadaPorUsuario ? corPrimaria : Colors.white;
    final corTexto = enviadaPorUsuario ? Colors.white : const Color(0xFF334155);

    return Align(
      alignment: enviadaPorUsuario
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 290),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          decoration: BoxDecoration(
            color: corFundo,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(22),
              topRight: const Radius.circular(22),
              bottomLeft: Radius.circular(enviadaPorUsuario ? 22 : 8),
              bottomRight: Radius.circular(enviadaPorUsuario ? 8 : 22),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x100F172A),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
            border: enviadaPorUsuario
                ? null
                : Border.all(color: const Color(0xFFE8EEF7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mensagem.texto,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: corTexto),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!enviadaPorUsuario)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: corDestaque,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (!enviadaPorUsuario) const SizedBox(width: 6),
                  Text(
                    mensagem.horario,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: enviadaPorUsuario
                          ? Colors.white.withValues(alpha: 0.88)
                          : const Color(0xFF8A9BB6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
