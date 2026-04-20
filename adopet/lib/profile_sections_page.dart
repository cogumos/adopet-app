import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_controller.dart';
import 'main.dart';
import 'notification_service.dart';

typedef SelecionarFotoPerfil = Future<void> Function(BuildContext context);

class MeusAnimaisPage extends StatelessWidget {
  final ContaRegistrada usuario;

  const MeusAnimaisPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: corFundoApp,
      appBar: _AppBarSecao(titulo: 'Meus animais'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _HeroSecaoPerfil(
            icone: Icons.pets_rounded,
            fundo: const Color(0xFFFFF4EA),
            corIcone: corPrimariaEscura,
            titulo: 'Acompanhamentos de ${usuario.primeiroNome}',
            subtitulo:
                'Veja os pets que você salvou, visitou ou está acompanhando com os abrigos.',
          ),
          const SizedBox(height: 18),
          Text('Em andamento', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 14),
          ..._meusAnimais.map(
            (animal) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CardAnimalPerfil(animal: animal),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoricoAdocaoPage extends StatelessWidget {
  final ContaRegistrada usuario;

  const HistoricoAdocaoPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: corFundoApp,
      appBar: _AppBarSecao(titulo: 'Histórico de adoção'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _HeroSecaoPerfil(
            icone: Icons.history_rounded,
            fundo: const Color(0xFFEEF4FF),
            corIcone: const Color(0xFF3B82F6),
            titulo: 'Sua jornada de adoção',
            subtitulo:
                'Acompanhe o progresso das conversas, visitas e análises dos pets que passaram pelo seu perfil.',
          ),
          const SizedBox(height: 18),
          Text('Atualizações recentes', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 14),
          ..._historicoAdocao.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CardHistoricoPerfil(
                item: item,
                nome: usuario.primeiroNome,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AjudaSuportePage extends StatelessWidget {
  final ContaRegistrada usuario;

  const AjudaSuportePage({super.key, required this.usuario});

  Future<void> _abrirSuporte(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Suporte AdoPet',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Nosso time pode ajudar com cadastro, favoritos, conversas com abrigos e processo de adoção.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              const _ContatoSuporteItem(
                icone: Icons.mail_outline_rounded,
                titulo: 'E-mail',
                valor: 'suporte@adopet.app',
              ),
              const SizedBox(height: 12),
              const _ContatoSuporteItem(
                icone: Icons.schedule_rounded,
                titulo: 'Horário',
                valor: 'Seg. a sex., das 9h às 18h',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: corPrimaria,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundoApp,
      appBar: _AppBarSecao(titulo: 'Ajuda e suporte'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _HeroSecaoPerfil(
            icone: Icons.help_outline_rounded,
            fundo: const Color(0xFFF6EEFF),
            corIcone: const Color(0xFFA855F7),
            titulo: 'Estamos com você',
            subtitulo:
                'Encontre respostas rápidas, orientações sobre adoção e canais de atendimento do app.',
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F0F172A),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: _faqAjuda
                  .map(
                    (faq) => ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: faq.fundo,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(faq.icone, color: faq.corIcone),
                      ),
                      title: Text(
                        faq.titulo,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF24324A),
                          fontSize: 17,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq.resposta.replaceAll(
                              '{nome}',
                              usuario.primeiroNome,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => _abrirSuporte(context),
            style: FilledButton.styleFrom(
              backgroundColor: corPrimaria,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Falar com suporte'),
          ),
        ],
      ),
    );
  }
}

class ConfiguracoesPage extends StatefulWidget {
  final AuthController auth;
  final SelecionarFotoPerfil onSelecionarFotoPerfil;

  const ConfiguracoesPage({
    super.key,
    required this.auth,
    required this.onSelecionarFotoPerfil,
  });

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  void _mostrarAviso(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _editarNome() async {
    final usuario = widget.auth.usuario;
    if (usuario == null) {
      return;
    }

    final controller = TextEditingController(text: usuario.nome);
    final resultado = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar nome'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Nome',
              hintText: 'Digite seu nome',
            ),
            onSubmitted: (_) => Navigator.of(context).pop(controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (!mounted || resultado == null) {
      return;
    }

    final sucesso = widget.auth.atualizarNome(resultado);
    _mostrarAviso(
      sucesso ? 'Nome atualizado com sucesso.' : 'Digite um nome válido.',
    );
  }

  Future<void> _alternarNotificacoes(bool valor) async {
    widget.auth.atualizarConfiguracoes(notificacoesAtivas: valor);

    if (valor) {
      await NotificationService.instance.mostrarMensagemPersonalizada(
        titulo: 'Notificações ativadas',
        corpo: 'Você continuará recebendo avisos importantes do AdoPet.',
      );
    }

    if (!mounted) {
      return;
    }

    _mostrarAviso(
      valor
          ? 'Notificações ativadas no seu perfil.'
          : 'Notificações desativadas para esta conta.',
    );
  }

  void _alternarLocalizacao(bool valor) {
    widget.auth.atualizarConfiguracoes(localizacaoAproximadaAtiva: valor);
    _mostrarAviso(
      valor
          ? 'Localização aproximada ativada na tela inicial.'
          : 'A tela inicial vai ocultar sua localização aproximada.',
    );
  }

  Future<void> _alternarTelaCheia(bool valor) async {
    widget.auth.atualizarConfiguracoes(telaCheiaAtiva: valor);
    await SystemChrome.setEnabledSystemUIMode(
      valor ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );

    if (!mounted) {
      return;
    }

    _mostrarAviso(
      valor
          ? 'Modo tela cheia ativado.'
          : 'Barras do sistema visíveis novamente.',
    );
  }

  Future<void> _confirmarSaida() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair da conta'),
          content: const Text(
            'Você pode entrar novamente quando quiser usando seu e-mail e sua senha.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    widget.auth.sair();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.auth,
      builder: (context, _) {
        final usuario = widget.auth.usuario;
        if (usuario == null) {
          return const Scaffold(backgroundColor: corFundoApp);
        }

        return Scaffold(
          backgroundColor: corFundoApp,
          appBar: _AppBarSecao(titulo: 'Configurações'),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _HeroSecaoPerfil(
                icone: Icons.settings_outlined,
                fundo: const Color(0xFFF2F5FA),
                corIcone: const Color(0xFF64748B),
                titulo: 'Ajustes da sua conta',
                subtitulo:
                    'Edite seu perfil, escolha o comportamento do app e controle sua experiência no AdoPet.',
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F0F172A),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _MiniAvatarPerfil(fotoPerfilPath: usuario.fotoPerfilPath),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario.nome,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            usuario.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.onSelecionarFotoPerfil(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF1E6),
                        foregroundColor: corPrimariaEscura,
                      ),
                      icon: const Icon(Icons.photo_camera_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _BlocoConfiguracoes(
                titulo: 'Conta',
                children: [
                  _TileConfiguracao(
                    icone: Icons.edit_outlined,
                    titulo: 'Editar nome',
                    subtitulo: usuario.nome,
                    onTap: _editarNome,
                  ),
                  _TileConfiguracao(
                    icone: Icons.person_rounded,
                    titulo: 'Foto de perfil',
                    subtitulo: 'Escolher outra imagem da galeria',
                    onTap: () => widget.onSelecionarFotoPerfil(context),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _BlocoConfiguracoes(
                titulo: 'Preferências',
                children: [
                  _TileConfiguracaoSwitch(
                    icone: Icons.notifications_none_rounded,
                    titulo: 'Notificações',
                    subtitulo: 'Avisos do app sobre login e novidades',
                    valor: usuario.notificacoesAtivas,
                    onChanged: _alternarNotificacoes,
                  ),
                  _TileConfiguracaoSwitch(
                    icone: Icons.location_on_outlined,
                    titulo: 'Localização aproximada',
                    subtitulo: 'Mostrar cidade ou região na tela inicial',
                    valor: usuario.localizacaoAproximadaAtiva,
                    onChanged: _alternarLocalizacao,
                  ),
                  _TileConfiguracaoSwitch(
                    icone: Icons.phone_android_rounded,
                    titulo: 'Tela cheia',
                    subtitulo: 'Ocultar barras do sistema durante o uso',
                    valor: usuario.telaCheiaAtiva,
                    onChanged: _alternarTelaCheia,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _BlocoConfiguracoes(
                titulo: 'Sessão',
                children: [
                  _TileConfiguracao(
                    icone: Icons.logout_rounded,
                    titulo: 'Sair da conta',
                    subtitulo: 'Encerrar sessão neste aparelho',
                    corIcone: const Color(0xFFEF4444),
                    fundoIcone: const Color(0xFFFFF0F0),
                    onTap: _confirmarSaida,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppBarSecao extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const _AppBarSecao({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: corFundoApp,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(titulo),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeroSecaoPerfil extends StatelessWidget {
  final IconData icone;
  final Color fundo;
  final Color corIcone;
  final String titulo;
  final String subtitulo;

  const _HeroSecaoPerfil({
    required this.icone,
    required this.fundo,
    required this.corIcone,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: fundo,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icone, color: corIcone, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 22,
                    color: const Color(0xFF24324A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitulo,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF7B8CA6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAnimalPerfil extends StatelessWidget {
  final _AnimalAcompanhado animal;

  const _CardAnimalPerfil({required this.animal});

  Future<void> _abrirDetalhes(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                animal.nome,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                animal.detalhes,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => _abrirDetalhes(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F0F172A),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child: Image.network(
                    animal.imagem,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFFFF1E6),
                        alignment: Alignment.center,
                        child: const Text('🐾', style: TextStyle(fontSize: 34)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: animal.corTag,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        animal.status,
                        style: const TextStyle(
                          color: Color(0xFF24324A),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      animal.nome,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF24324A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      animal.subtitulo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFC4CFDE),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardHistoricoPerfil extends StatelessWidget {
  final _HistoricoItem item;
  final String nome;

  const _CardHistoricoPerfil({required this.item, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.fundoIcone,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(item.icone, color: item.corIcone),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.titulo,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF24324A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.descricao.replaceAll('{nome}', nome),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ...item.passos.map(
            (passo) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: passo.concluido
                          ? const Color(0xFFFFF1E6)
                          : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      passo.concluido
                          ? Icons.check_rounded
                          : Icons.more_horiz_rounded,
                      size: 15,
                      color: passo.concluido
                          ? corPrimariaEscura
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      passo.rotulo,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlocoConfiguracoes extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const _BlocoConfiguracoes({required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F0F172A),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _TileConfiguracao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final Color fundoIcone;
  final Color corIcone;

  const _TileConfiguracao({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.fundoIcone = const Color(0xFFF8FAFC),
    this.corIcone = const Color(0xFF64748B),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: fundoIcone,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icone, color: corIcone),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF24324A),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFC4CFDE),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileConfiguracaoSwitch extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final bool valor;
  final ValueChanged<bool> onChanged;

  const _TileConfiguracaoSwitch({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icone, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF24324A),
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitulo, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Switch.adaptive(
            value: valor,
            activeThumbColor: corPrimaria,
            activeTrackColor: const Color(0xFFFFD3AE),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _MiniAvatarPerfil extends StatelessWidget {
  final String? fotoPerfilPath;

  const _MiniAvatarPerfil({this.fotoPerfilPath});

  @override
  Widget build(BuildContext context) {
    final possuiFoto =
        fotoPerfilPath != null && File(fotoPerfilPath!).existsSync();

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FB),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: possuiFoto
            ? Image.file(File(fotoPerfilPath!), fit: BoxFit.cover)
            : const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF94A3B8),
                size: 34,
              ),
      ),
    );
  }
}

class _ContatoSuporteItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _ContatoSuporteItem({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icone, color: corPrimariaEscura),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF24324A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(valor, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimalAcompanhado {
  final String nome;
  final String imagem;
  final String status;
  final String subtitulo;
  final String detalhes;
  final Color corTag;

  const _AnimalAcompanhado({
    required this.nome,
    required this.imagem,
    required this.status,
    required this.subtitulo,
    required this.detalhes,
    required this.corTag,
  });
}

class _HistoricoItem {
  final IconData icone;
  final Color fundoIcone;
  final Color corIcone;
  final String titulo;
  final String descricao;
  final List<_PassoHistorico> passos;

  const _HistoricoItem({
    required this.icone,
    required this.fundoIcone,
    required this.corIcone,
    required this.titulo,
    required this.descricao,
    required this.passos,
  });
}

class _PassoHistorico {
  final String rotulo;
  final bool concluido;

  const _PassoHistorico({required this.rotulo, required this.concluido});
}

class _ItemFaq {
  final IconData icone;
  final Color fundo;
  final Color corIcone;
  final String titulo;
  final String resposta;

  const _ItemFaq({
    required this.icone,
    required this.fundo,
    required this.corIcone,
    required this.titulo,
    required this.resposta,
  });
}

const _meusAnimais = [
  _AnimalAcompanhado(
    nome: 'Bidu',
    imagem:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=300',
    status: 'Visita marcada',
    subtitulo: 'Abrigo Patas Felizes • amanhã às 14h',
    detalhes:
        'Sua visita com o Bidu está confirmada. O abrigo preparou o histórico de vacinas e a ficha comportamental para você conhecer tudo com calma.',
    corTag: Color(0xFFFFF1E6),
  ),
  _AnimalAcompanhado(
    nome: 'Luna',
    imagem:
        'https://images.unsplash.com/photo-1513245543132-31f507417b26?auto=format&fit=crop&q=80&w=300',
    status: 'Em conversa',
    subtitulo: 'Associação Miados • resposta recente',
    detalhes:
        'A equipe enviou novas fotos, explicou a rotina da Luna e está aguardando sua confirmação para a primeira visita.',
    corTag: Color(0xFFF5F3FF),
  ),
];

const _historicoAdocao = [
  _HistoricoItem(
    icone: Icons.assignment_turned_in_outlined,
    fundoIcone: Color(0xFFFFF4EA),
    corIcone: corPrimariaEscura,
    titulo: 'Processo do Bidu',
    descricao:
        '{nome}, seu interesse pelo Bidu avançou bem. O abrigo já validou seus dados e a visita está na última etapa antes da decisão final.',
    passos: [
      _PassoHistorico(
        rotulo: 'Interesse enviado para o abrigo',
        concluido: true,
      ),
      _PassoHistorico(rotulo: 'Perfil analisado pela equipe', concluido: true),
      _PassoHistorico(rotulo: 'Visita presencial confirmada', concluido: true),
      _PassoHistorico(rotulo: 'Retorno final do abrigo', concluido: false),
    ],
  ),
  _HistoricoItem(
    icone: Icons.forum_outlined,
    fundoIcone: Color(0xFFEEF4FF),
    corIcone: Color(0xFF3B82F6),
    titulo: 'Conversa sobre Luna',
    descricao:
        'O tutor responsável pela Luna respondeu suas dúvidas e enviou orientações sobre adaptação, alimentação e rotina da gata.',
    passos: [
      _PassoHistorico(rotulo: 'Primeiro contato realizado', concluido: true),
      _PassoHistorico(
        rotulo: 'Dúvidas respondidas pelo tutor',
        concluido: true,
      ),
      _PassoHistorico(rotulo: 'Agendamento de encontro', concluido: false),
    ],
  ),
];

const _faqAjuda = [
  _ItemFaq(
    icone: Icons.pets_rounded,
    fundo: Color(0xFFFFF4EA),
    corIcone: corPrimariaEscura,
    titulo: 'Como funciona a adoção no app?',
    resposta:
        'Você escolhe um pet, conversa com o abrigo ou tutor e acompanha as próximas etapas dentro do seu perfil até a visita e a conclusão.',
  ),
  _ItemFaq(
    icone: Icons.lock_outline_rounded,
    fundo: Color(0xFFF1F5F9),
    corIcone: Color(0xFF64748B),
    titulo: 'Meus dados estão seguros?',
    resposta:
        'Sim. Seus dados da conta ficam vinculados ao seu perfil e são usados apenas para personalizar a experiência de {nome} dentro do AdoPet.',
  ),
  _ItemFaq(
    icone: Icons.favorite_border_rounded,
    fundo: Color(0xFFFFF0F0),
    corIcone: Color(0xFFEF4444),
    titulo: 'Não consigo salvar favoritos',
    resposta:
        'Confira se você está com a sessão iniciada. Sem login, as abas de favoritos e mensagens ficam bloqueadas para proteger sua experiência.',
  ),
];
