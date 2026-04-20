import 'package:flutter/material.dart';

import 'main.dart';
import 'pet_detail_page.dart';

const _favoritos = [
  FavoritoItem(
    id: 1,
    nome: 'Bidu',
    raca: 'Golden Retriever',
    idade: '2 anos',
    distancia: '1,5 km',
    genero: 'Macho',
    imagem:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=600',
  ),
  FavoritoItem(
    id: 4,
    nome: 'Mel',
    raca: 'Beagle',
    idade: '1 ano',
    distancia: '5,0 km',
    genero: 'Fêmea',
    imagem:
        'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&q=80&w=600',
  ),
  FavoritoItem(
    id: 2,
    nome: 'Luna',
    raca: 'Siamesa',
    idade: '6 meses',
    distancia: '3,2 km',
    genero: 'Fêmea',
    imagem:
        'https://images.unsplash.com/photo-1513245543132-31f507417b26?auto=format&fit=crop&q=80&w=600',
  ),
  FavoritoItem(
    id: 7,
    nome: 'Theo',
    raca: 'Vira-lata Caramelo',
    idade: '8 meses',
    distancia: '2,4 km',
    genero: 'Macho',
    imagem:
        'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&q=80&w=600',
  ),
];

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

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
                  compacto ? 24 : 28,
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Favoritos',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: compacto ? 28 : 32,
                            color: const Color(0xFF24324A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: compacto ? 66 : 74,
                      height: compacto ? 66 : 74,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFEF4444),
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, compacto ? 148 : 164),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final largura = constraints.crossAxisExtent;
                  final colunas = largura >= 760 ? 3 : (largura >= 320 ? 2 : 1);
                  final larguraCard =
                      (largura - ((colunas - 1) * 18)) / colunas;
                  final alturaCard = larguraCard + (compacto ? 134.0 : 142.0);

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final favorito = _favoritos[index];
                      return _CardFavorito(
                        item: favorito,
                        compacto: compacto,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PetDetalhePage(
                                detalhe: detalhePet(
                                  id: favorito.id,
                                  nome: favorito.nome,
                                  raca: favorito.raca,
                                  idade: favorito.idade,
                                  imagem: favorito.imagem,
                                  genero: favorito.genero,
                                  distancia: favorito.distancia,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }, childCount: _favoritos.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colunas,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      mainAxisExtent: alturaCard,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFavorito extends StatelessWidget {
  final FavoritoItem item;
  final bool compacto;
  final VoidCallback onTap;

  const _CardFavorito({
    required this.item,
    required this.compacto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(compacto ? 14 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x100F172A),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          item.imagem,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFFFEDD5),
                              alignment: Alignment.center,
                              child: const Text(
                                '🐾',
                                style: TextStyle(fontSize: 44),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: compacto ? 48 : 52,
                          height: compacto ? 48 : 52,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFEF4444),
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: compacto ? 14 : 16),
              Text(
                item.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: compacto ? 20 : 22,
                  color: const Color(0xFF173052),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.raca,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF8EA0BC),
                  fontSize: compacto ? 15 : 16,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.idade,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF5B7497),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: compacto ? 42 : 46,
                    height: compacto ? 42 : 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5EC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: corPrimariaEscura,
                      size: 26,
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

class FavoritoItem {
  final int id;
  final String nome;
  final String raca;
  final String idade;
  final String distancia;
  final String genero;
  final String imagem;

  const FavoritoItem({
    required this.id,
    required this.nome,
    required this.raca,
    required this.idade,
    required this.distancia,
    required this.genero,
    required this.imagem,
  });
}
