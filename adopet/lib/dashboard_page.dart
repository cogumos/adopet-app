import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'auth_controller.dart';
import 'chat_page.dart';
import 'favorites_page.dart';
import 'main.dart';
import 'pet_detail_page.dart';
import 'profile_page.dart';

const _categorias = [
  CategoriaPet(
    id: 'todos',
    label: 'Todos',
    corDestaque: Color(0xFFFFF1E6),
    icone: Icons.pets_rounded,
  ),
  CategoriaPet(
    id: 'caes',
    label: 'Cães',
    foto:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=120',
    corDestaque: Color(0xFFFFF1E6),
  ),
  CategoriaPet(
    id: 'gatos',
    label: 'Gatos',
    foto:
        'https://images.unsplash.com/photo-1513245543132-31f507417b26?auto=format&fit=crop&q=80&w=120',
    corDestaque: Color(0xFFF5F3FF),
  ),
  CategoriaPet(
    id: 'aves',
    label: 'Aves',
    foto:
        'https://images.unsplash.com/photo-1444464666168-49d633b86797?auto=format&fit=crop&q=80&w=120',
    corDestaque: Color(0xFFF0FDF4),
  ),
  CategoriaPet(
    id: 'coelhos',
    label: 'Coelhos',
    foto:
        'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&q=80&w=120',
    corDestaque: Color(0xFFFFFBEB),
  ),
];

const _pets = [
  PetItem(
    id: 1,
    nome: 'Bidu',
    raca: 'Golden Retriever',
    idade: '2 anos',
    distancia: '1,5 km',
    genero: 'Macho',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 2,
    nome: 'Luna',
    raca: 'Siamesa',
    idade: '6 meses',
    distancia: '3,2 km',
    genero: 'Fêmea',
    categoria: 'gatos',
    imagem:
        'https://images.unsplash.com/photo-1513245543132-31f507417b26?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 3,
    nome: 'Rex',
    raca: 'Pastor Alemão',
    idade: '4 anos',
    distancia: '0,8 km',
    genero: 'Macho',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 4,
    nome: 'Mel',
    raca: 'Beagle',
    idade: '1 ano',
    distancia: '5,0 km',
    genero: 'Fêmea',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 5,
    nome: 'Floquinho',
    raca: 'Poodle',
    idade: '3 anos',
    distancia: '2,1 km',
    genero: 'Macho',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 6,
    nome: 'Nina',
    raca: 'Persa',
    idade: '1 ano',
    distancia: '1,1 km',
    genero: 'Fêmea',
    categoria: 'gatos',
    imagem:
        'https://images.unsplash.com/photo-1519052537078-e6302a4968d4?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 7,
    nome: 'Theo',
    raca: 'Vira-lata Caramelo',
    idade: '8 meses',
    distancia: '2,4 km',
    genero: 'Macho',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 8,
    nome: 'Amora',
    raca: 'Maine Coon',
    idade: '2 anos',
    distancia: '4,1 km',
    genero: 'Fêmea',
    categoria: 'gatos',
    imagem:
        'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 9,
    nome: 'Kiwi',
    raca: 'Calopsita',
    idade: '1 ano',
    distancia: '3,8 km',
    genero: 'Macho',
    categoria: 'aves',
    imagem:
        'https://images.unsplash.com/photo-1444464666168-49d633b86797?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 10,
    nome: 'Sol',
    raca: 'Canário',
    idade: '9 meses',
    distancia: '2,9 km',
    genero: 'Fêmea',
    categoria: 'aves',
    imagem:
        'https://images.unsplash.com/photo-1452570053594-1b985d6ea890?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 11,
    nome: 'Pipoca',
    raca: 'Mini Lop',
    idade: '7 meses',
    distancia: '1,7 km',
    genero: 'Fêmea',
    categoria: 'coelhos',
    imagem:
        'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 12,
    nome: 'Cacau',
    raca: 'Lion Head',
    idade: '1 ano',
    distancia: '4,8 km',
    genero: 'Macho',
    categoria: 'coelhos',
    imagem:
        'https://images.unsplash.com/photo-1583301286816-f4f05e1e8b25?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 13,
    nome: 'Maya',
    raca: 'Shih Tzu',
    idade: '2 anos',
    distancia: '900 m',
    genero: 'Fêmea',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1525253013412-55c1a69a5738?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 14,
    nome: 'Tom',
    raca: 'Azul Russo',
    idade: '3 anos',
    distancia: '2,0 km',
    genero: 'Macho',
    categoria: 'gatos',
    imagem:
        'https://images.unsplash.com/photo-1494256997604-768d1f608cac?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 15,
    nome: 'Bento',
    raca: 'Dachshund',
    idade: '5 anos',
    distancia: '3,5 km',
    genero: 'Macho',
    categoria: 'caes',
    imagem:
        'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&q=80&w=300',
  ),
  PetItem(
    id: 16,
    nome: 'Lili',
    raca: 'Periquito',
    idade: '6 meses',
    distancia: '5,2 km',
    genero: 'Fêmea',
    categoria: 'aves',
    imagem:
        'https://images.unsplash.com/photo-1522926193341-e9ffd686c60f?auto=format&fit=crop&q=80&w=300',
  ),
];

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final buscaController = TextEditingController();
  late final Future<String> localizacaoFuture;
  String categoriaSelecionada = 'todos';
  String busca = '';
  int abaAtual = 0;

  CategoriaPet get categoriaAtual => _categorias.firstWhere(
    (categoria) => categoria.id == categoriaSelecionada,
  );

  String _normalizarTexto(String valor) {
    const mapaAcentos = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'õ': 'o',
      'ô': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
    };

    return valor
        .toLowerCase()
        .split('')
        .map((caractere) => mapaAcentos[caractere] ?? caractere)
        .join()
        .trim();
  }

  String _textoPetNormalizado(PetItem pet) {
    return '${_normalizarTexto(pet.nome)} ${_normalizarTexto(pet.raca)}';
  }

  List<PetItem> get petsFiltrados {
    final termo = _normalizarTexto(busca);
    return _pets.where((pet) {
      final combinaCategoria =
          categoriaSelecionada == 'todos' ||
          pet.categoria == categoriaSelecionada;
      final combinaBusca =
          termo.isEmpty || _textoPetNormalizado(pet).contains(termo);
      return combinaCategoria && combinaBusca;
    }).toList();
  }

  int totalPorCategoria(String categoriaId) {
    final termo = _normalizarTexto(busca);
    return _pets.where((pet) {
      final combinaCategoria =
          categoriaId == 'todos' || pet.categoria == categoriaId;
      final combinaBusca =
          termo.isEmpty || _textoPetNormalizado(pet).contains(termo);
      return combinaCategoria && combinaBusca;
    }).length;
  }

  String get resumoResultados {
    final total = petsFiltrados.length;
    if (categoriaSelecionada == 'todos') {
      return '$total pets disponíveis hoje';
    }

    return '$total ${categoriaAtual.label.toLowerCase()} disponíveis';
  }

  void _resetarFiltros() {
    setState(() {
      categoriaSelecionada = 'todos';
      busca = '';
      buscaController.clear();
    });
  }

  void _limparBusca() {
    setState(() {
      busca = '';
      buscaController.clear();
    });
  }

  void _atualizarBusca(String valor) {
    setState(() {
      busca = valor;
      if (valor.trim().isNotEmpty) {
        categoriaSelecionada = 'todos';
      }
    });
  }

  void _selecionarAba(int indice) {
    setState(() {
      abaAtual = indice;
    });
  }

  @override
  void initState() {
    super.initState();
    localizacaoFuture = _buscarLocalizacaoAproximada();
  }

  Future<String> _buscarLocalizacaoAproximada() async {
    final cliente = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5)
      ..userAgent = 'AdoPet/1.0';

    try {
      final requisicao = await cliente.getUrl(Uri.parse('https://ipwho.is/'));
      requisicao.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final resposta = await requisicao.close().timeout(
        const Duration(seconds: 5),
      );

      if (resposta.statusCode == 200) {
        final conteudo = await resposta.transform(utf8.decoder).join();
        final mapa = jsonDecode(conteudo);

        if (mapa is Map<String, dynamic>) {
          final cidade = _textoLocalizacao(mapa['city']);
          final estado = _textoLocalizacao(mapa['region']);
          final pais = _textoLocalizacao(mapa['country_code']);
          final partes = [
            if (cidade != null) cidade,
            if (estado != null && estado != cidade) estado,
            if (pais != null && pais != 'BR') pais,
          ];

          if (partes.isNotEmpty) {
            return partes.join(' • ');
          }
        }
      }
    } catch (_) {
    } finally {
      cliente.close(force: true);
    }

    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final pais = locale.countryCode?.toUpperCase();
    if (pais == 'BR') {
      return 'Brasil';
    }
    if (pais != null && pais.isNotEmpty) {
      return pais;
    }
    return 'Perto de você';
  }

  String? _textoLocalizacao(dynamic valor) {
    if (valor is! String) {
      return null;
    }

    final texto = valor.trim();
    if (texto.isEmpty) {
      return null;
    }
    return texto;
  }

  Future<void> _abrirTodasCategorias() async {
    final categoria = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => CategoriasPage(
          categoriaSelecionada: categoriaSelecionada,
          totalPorCategoria: totalPorCategoria,
        ),
      ),
    );

    if (!mounted || categoria == null) {
      return;
    }

    setState(() {
      categoriaSelecionada = categoria;
    });
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  Widget _buildConteudoAtual(
    bool larguraCompacta,
    List<PetItem> resultados, {
    required bool autenticado,
    required String nomeExibicao,
    required String? fotoPerfilPath,
    required bool localizacaoAproximadaAtiva,
  }) {
    final filtrosAtivos =
        categoriaSelecionada != 'todos' || busca.trim().isNotEmpty;

    switch (abaAtual) {
      case 1:
        if (!autenticado) {
          return PaginaSessaoNecessaria(
            key: const ValueKey('favoritos-bloqueado'),
            titulo: 'Favoritos',
            descricao:
                'Entre ou crie uma conta para salvar e revisar os animais que você mais gostou.',
            onAbrirPerfil: () => _selecionarAba(3),
          );
        }
        return const FavoritesPage(key: ValueKey('favoritos'));
      case 2:
        if (!autenticado) {
          return PaginaSessaoNecessaria(
            key: const ValueKey('chat-bloqueado'),
            titulo: 'Mensagens',
            descricao:
                'Entre na sua conta para conversar com abrigos, ONGs e tutores dos animais.',
            onAbrirPerfil: () => _selecionarAba(3),
          );
        }
        return const ChatPage(key: ValueKey('chat'));
      case 3:
        return const ProfilePage(key: ValueKey('perfil'));
      default:
        return _DashboardInicioView(
          key: const ValueKey('inicio'),
          autenticado: autenticado,
          buscaController: buscaController,
          categoriaSelecionada: categoriaSelecionada,
          filtrosAtivos: filtrosAtivos,
          larguraCompacta: larguraCompacta,
          resultados: resultados,
          resumoResultados: resumoResultados,
          nomeExibicao: nomeExibicao,
          fotoPerfilPath: fotoPerfilPath,
          localizacaoAproximadaAtiva: localizacaoAproximadaAtiva,
          localizacaoFuture: localizacaoFuture,
          onAbrirPerfil: () => _selecionarAba(3),
          onVerTodasCategorias: _abrirTodasCategorias,
          onBuscarAlterada: _atualizarBusca,
          onLimparBusca: _limparBusca,
          onResetarFiltros: _resetarFiltros,
          onSelecionarCategoria: (categoriaId) {
            setState(() {
              categoriaSelecionada = categoriaId;
            });
          },
          totalPorCategoria: totalPorCategoria,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AppAuthScope.watch(context);
    final larguraCompacta = MediaQuery.sizeOf(context).width < 380;
    final resultados = petsFiltrados;
    final nomeExibicao = auth.usuario?.primeiroNome ?? 'Humano';
    final fotoPerfilPath = auth.usuario?.fotoPerfilPath;
    final localizacaoAproximadaAtiva =
        auth.usuario?.localizacaoAproximadaAtiva ?? true;

    return Scaffold(
      backgroundColor: corFundoApp,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _buildConteudoAtual(
          larguraCompacta,
          resultados,
          autenticado: auth.autenticado,
          nomeExibicao: nomeExibicao,
          fotoPerfilPath: fotoPerfilPath,
          localizacaoAproximadaAtiva: localizacaoAproximadaAtiva,
        ),
      ),
      bottomNavigationBar: DockNavegacao(
        abaAtual: abaAtual,
        compacto: larguraCompacta,
        onSelecionar: _selecionarAba,
        onTapCentral: () => _selecionarAba(0),
      ),
    );
  }
}

class _DashboardInicioView extends StatelessWidget {
  final bool autenticado;
  final TextEditingController buscaController;
  final String categoriaSelecionada;
  final bool filtrosAtivos;
  final bool larguraCompacta;
  final List<PetItem> resultados;
  final String resumoResultados;
  final String nomeExibicao;
  final String? fotoPerfilPath;
  final bool localizacaoAproximadaAtiva;
  final Future<String> localizacaoFuture;
  final VoidCallback onAbrirPerfil;
  final VoidCallback onVerTodasCategorias;
  final ValueChanged<String> onBuscarAlterada;
  final VoidCallback onLimparBusca;
  final VoidCallback onResetarFiltros;
  final ValueChanged<String> onSelecionarCategoria;
  final int Function(String categoriaId) totalPorCategoria;

  const _DashboardInicioView({
    super.key,
    required this.autenticado,
    required this.buscaController,
    required this.categoriaSelecionada,
    required this.filtrosAtivos,
    required this.larguraCompacta,
    required this.resultados,
    required this.resumoResultados,
    required this.nomeExibicao,
    required this.fotoPerfilPath,
    required this.localizacaoAproximadaAtiva,
    required this.localizacaoFuture,
    required this.onAbrirPerfil,
    required this.onVerTodasCategorias,
    required this.onBuscarAlterada,
    required this.onLimparBusca,
    required this.onResetarFiltros,
    required this.onSelecionarCategoria,
    required this.totalPorCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final possuiFotoPerfil =
        fotoPerfilPath != null && File(fotoPerfilPath!).existsSync();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            decoration: const BoxDecoration(
              color: corFundoBase,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: onAbrirPerfil,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: possuiFotoPerfil
                                ? Image.file(
                                    File(fotoPerfilPath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person_outline_rounded,
                                        color: Color(0xFF94A3B8),
                                        size: 28,
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.person_outline_rounded,
                                    color: Color(0xFF94A3B8),
                                    size: 28,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, $nomeExibicao!',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: buscaController,
                          onChanged: onBuscarAlterada,
                          textInputAction: TextInputAction.search,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Buscar por raça ou nome...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF94A3B8),
                            ),
                            suffixIcon: buscaController.text.trim().isEmpty
                                ? null
                                : IconButton(
                                    onPressed: onLimparBusca,
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: filtrosAtivos
                            ? corPrimaria
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22FF8F2B),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: onResetarFiltros,
                        icon: Icon(
                          Icons.tune_rounded,
                          color: filtrosAtivos
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Categorias',
                                style: theme.textTheme.headlineSmall,
                              ),
                            ),
                            TextButton(
                              onPressed: onVerTodasCategorias,
                              child: const Text('Ver todas'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categorias.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final categoria = _categorias[index];
                              final ativa =
                                  categoria.id == categoriaSelecionada;

                              return _ChipCategoria(
                                categoria: categoria,
                                ativa: ativa,
                                total: totalPorCategoria(categoria.id),
                                onTap: () =>
                                    onSelecionarCategoria(categoria.id),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Próximos a você',
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    resumoResultados,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF64748B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            localizacaoAproximadaAtiva
                                ? FutureBuilder<String>(
                                    future: localizacaoFuture,
                                    builder: (context, snapshot) {
                                      final texto =
                                          snapshot.connectionState ==
                                                  ConnectionState.waiting &&
                                              !(snapshot.hasData)
                                          ? 'Localizando...'
                                          : (snapshot.data ?? 'Perto de você');

                                      return _ChipLocalizacao(texto: texto);
                                    },
                                  )
                                : const _ChipLocalizacao(
                                    texto: 'Localização oculta',
                                    icone: Icons.location_off_rounded,
                                  ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 150),
                  sliver: resultados.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.search_off_rounded,
                                  size: 44,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Nenhum pet encontrado',
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tente outro nome, raça ou categoria.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList.separated(
                          itemCount: resultados.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final pet = resultados[index];
                            return CardPet(
                              item: pet,
                              compacto: larguraCompacta,
                              exibirFavorito: autenticado,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PetDetalhePage(
                                      detalhe: detalhePet(
                                        id: pet.id,
                                        nome: pet.nome,
                                        raca: pet.raca,
                                        idade: pet.idade,
                                        imagem: pet.imagem,
                                        genero: pet.genero,
                                        distancia: pet.distancia,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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

class _ChipLocalizacao extends StatelessWidget {
  final String texto;
  final IconData icone;

  const _ChipLocalizacao({
    required this.texto,
    this.icone = Icons.location_on_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 170),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEDD5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 14, color: corPrimaria),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                texto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: corPrimariaEscura,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardPet extends StatelessWidget {
  final PetItem item;
  final bool compacto;
  final bool exibirFavorito;
  final VoidCallback onTap;

  const CardPet({
    super.key,
    required this.item,
    required this.compacto,
    required this.exibirFavorito,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feminino = item.genero == 'Fêmea';
    final imagemTamanho = compacto ? 110.0 : 122.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0x00FFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 12,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    SizedBox(
                      width: imagemTamanho,
                      height: imagemTamanho,
                      child: Image.network(
                        item.imagem,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFFFEDD5),
                            alignment: Alignment.center,
                            child: const Text(
                              '🐾',
                              style: TextStyle(fontSize: 42),
                            ),
                          );
                        },
                      ),
                    ),
                    if (exibirFavorito)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.86),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            feminino
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: const Color(0xFFEF4444),
                            size: 17,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.nome,
                              style: theme.textTheme.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: feminino
                                  ? const Color(0xFFFCE7F3)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.genero,
                              style: TextStyle(
                                color: feminino
                                    ? const Color(0xFFDB2777)
                                    : const Color(0xFF2563EB),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.raca,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: compacto ? 18 : 22),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: corPrimaria,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.distancia,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.idade,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF334155),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: corPrimaria,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginaSessaoNecessaria extends StatelessWidget {
  final String titulo;
  final String descricao;
  final VoidCallback onAbrirPerfil;

  const PaginaSessaoNecessaria({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.onAbrirPerfil,
  });

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
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24, compacto ? 20 : 24, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  titulo,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF24324A),
                    fontSize: compacto ? 28 : 30,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                24,
                compacto ? 20 : 28,
                24,
                compacto ? 132 : 148,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(compacto ? 22 : 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x120F172A),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: compacto ? 68 : 76,
                            height: compacto ? 68 : 76,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1E6),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Icon(
                              Icons.lock_outline_rounded,
                              color: corPrimariaEscura,
                              size: compacto ? 30 : 34,
                            ),
                          ),
                          SizedBox(height: compacto ? 16 : 20),
                          Text(
                            'Faça login para continuar',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF24324A),
                              fontSize: compacto ? 23 : 26,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            descricao,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF7B8CA6),
                              fontSize: compacto ? 15 : 16,
                            ),
                          ),
                          SizedBox(height: compacto ? 18 : 22),
                          FilledButton(
                            onPressed: onAbrirPerfil,
                            style: FilledButton.styleFrom(
                              minimumSize: Size.fromHeight(compacto ? 52 : 56),
                              backgroundColor: corPrimaria,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: const Text('Entrar ou criar conta'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriasPage extends StatelessWidget {
  final String categoriaSelecionada;
  final int Function(String categoriaId) totalPorCategoria;

  const CategoriasPage({
    super.key,
    required this.categoriaSelecionada,
    required this.totalPorCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: corFundoApp,
      appBar: AppBar(
        backgroundColor: corFundoBase,
        elevation: 0,
        title: Text(
          'Categorias',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF24324A),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          physics: const BouncingScrollPhysics(),
          itemCount: _categorias.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final categoria = _categorias[index];
            final ativa = categoria.id == categoriaSelecionada;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () => Navigator.of(context).pop(categoria.id),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: ativa ? corPrimaria : const Color(0xFFF1F5F9),
                      width: ativa ? 1.6 : 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D0F172A),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _AvatarCategoria(categoria: categoria, ativa: ativa),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoria.label,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF24324A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${totalPorCategoria(categoria.id)} disponíveis',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: ativa
                              ? const Color(0xFFFFF1E6)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: ativa
                              ? corPrimariaEscura
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DockNavegacao extends StatelessWidget {
  final int abaAtual;
  final bool compacto;
  final ValueChanged<int> onSelecionar;
  final VoidCallback onTapCentral;

  const DockNavegacao({
    super.key,
    required this.abaAtual,
    required this.compacto,
    required this.onSelecionar,
    required this.onTapCentral,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final altura = compacto ? 92.0 : 98.0;
    final espacoCentral = compacto ? 78.0 : 86.0;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        12,
        0,
        12,
        bottomInset > 0 ? bottomInset : 10,
      ),
      child: SizedBox(
        height: altura,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              top: 16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compacto ? 8 : 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ItemNavegacao(
                        icone: Icons.home_rounded,
                        rotulo: 'Home',
                        ativo: abaAtual == 0,
                        compacto: compacto,
                        onTap: () => onSelecionar(0),
                      ),
                    ),
                    Expanded(
                      child: ItemNavegacao(
                        icone: Icons.favorite_border_rounded,
                        rotulo: 'Favoritos',
                        ativo: abaAtual == 1,
                        compacto: compacto,
                        onTap: () => onSelecionar(1),
                      ),
                    ),
                    SizedBox(width: espacoCentral),
                    Expanded(
                      child: ItemNavegacao(
                        icone: Icons.chat_bubble_outline_rounded,
                        rotulo: 'Chat',
                        ativo: abaAtual == 2,
                        compacto: compacto,
                        onTap: () => onSelecionar(2),
                      ),
                    ),
                    Expanded(
                      child: ItemNavegacao(
                        icone: Icons.person_outline_rounded,
                        rotulo: 'Perfil',
                        ativo: abaAtual == 3,
                        compacto: compacto,
                        onTap: () => onSelecionar(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onTapCentral,
                child: Container(
                  width: compacto ? 68 : 74,
                  height: compacto ? 68 : 74,
                  decoration: BoxDecoration(
                    color: corPrimaria,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22FF8F2B),
                        blurRadius: 22,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemNavegacao extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final bool ativo;
  final bool compacto;
  final VoidCallback onTap;

  const ItemNavegacao({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.ativo,
    required this.compacto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: compacto ? 22 : 24,
              color: ativo ? corPrimaria : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                rotulo,
                maxLines: 1,
                style: TextStyle(
                  color: ativo ? corPrimaria : const Color(0xFF94A3B8),
                  fontSize: compacto ? 9 : 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriaPet {
  final String id;
  final String label;
  final String? foto;
  final IconData? icone;
  final Color corDestaque;

  const CategoriaPet({
    required this.id,
    required this.label,
    this.foto,
    this.icone,
    required this.corDestaque,
  });
}

class _ChipCategoria extends StatelessWidget {
  final CategoriaPet categoria;
  final bool ativa;
  final int total;
  final VoidCallback onTap;

  const _ChipCategoria({
    required this.categoria,
    required this.ativa,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: ativa ? corPrimaria : const Color(0xFFF1F5F9),
              width: ativa ? 1.6 : 1,
            ),
            boxShadow: ativa
                ? const [
                    BoxShadow(
                      color: Color(0x1FFF8F2B),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AvatarCategoria(categoria: categoria, ativa: ativa),
              const SizedBox(width: 10),
              Text(
                categoria.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF24324A),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ativa
                      ? categoria.corDestaque
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$total',
                  style: TextStyle(
                    color: ativa ? corPrimariaEscura : const Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarCategoria extends StatelessWidget {
  final CategoriaPet categoria;
  final bool ativa;

  const _AvatarCategoria({required this.categoria, required this.ativa});

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: categoria.corDestaque,
        shape: BoxShape.circle,
      ),
      child: categoria.foto == null
          ? Icon(
              categoria.icone ?? Icons.pets_rounded,
              color: corPrimariaEscura,
              size: 22,
            )
          : ClipOval(
              child: Image.network(
                categoria.foto!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    categoria.icone ?? Icons.pets_rounded,
                    color: corPrimariaEscura,
                    size: 22,
                  );
                },
              ),
            ),
    );

    if (!ativa) {
      return avatar;
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: corPrimaria, width: 1.5),
      ),
      child: avatar,
    );
  }
}

class PetItem {
  final int id;
  final String nome;
  final String raca;
  final String idade;
  final String distancia;
  final String imagem;
  final String genero;
  final String categoria;

  const PetItem({
    required this.id,
    required this.nome,
    required this.raca,
    required this.idade,
    required this.distancia,
    required this.imagem,
    required this.genero,
    required this.categoria,
  });
}
