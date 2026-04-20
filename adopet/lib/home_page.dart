import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [corFundoClaro, corFundoBase],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compacto = constraints.maxHeight < 720;
                final hero = math.min(
                  constraints.maxWidth * 0.72,
                  compacto ? 228.0 : 272.0,
                );

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 850),
                  curve: Curves.easeOutCubic,
                  builder: (context, valor, child) {
                    final topo = _entrada(valor, 0.0, 0.55);
                    final meio = _entrada(valor, 0.15, 0.82);
                    final base = _entrada(valor, 0.28, 1.0);

                    return Column(
                      children: [
                        _EntradaSuave(
                          progresso: topo,
                          deslocamento: 18,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(compacto ? 16 : 18),
                                decoration: BoxDecoration(
                                  color: corPrimaria,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x22FF8F2B),
                                      blurRadius: 26,
                                      offset: Offset(0, 14),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.pets_rounded,
                                  size: compacto ? 42 : 48,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 18),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(fontSize: compacto ? 34 : 40),
                                  children: const [
                                    TextSpan(text: 'Ado'),
                                    TextSpan(
                                      text: 'Pet',
                                      style: TextStyle(color: corPrimaria),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _EntradaSuave(
                          progresso: meio,
                          deslocamento: 24,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: hero + 26,
                                  height: hero + 26,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: hero + 14,
                                        height: hero + 14,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              const Color(
                                                0xFFFFC9A8,
                                              ).withValues(alpha: 0.45),
                                              const Color(
                                                0xFFFFC9A8,
                                              ).withValues(alpha: 0),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 0,
                                        child: _CoracaoFlutuante(
                                          compacto: compacto,
                                        ),
                                      ),
                                      Container(
                                        width: hero,
                                        height: hero,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE7D7),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x1F000000),
                                              blurRadius: 34,
                                              offset: Offset(0, 22),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&q=80&w=400',
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }

                                                  return const Center(
                                                    child: SizedBox(
                                                      width: 36,
                                                      height: 36,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 3,
                                                            color: corPrimaria,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Center(
                                                    child: Text(
                                                      '🐶',
                                                      style: TextStyle(
                                                        fontSize: hero * 0.42,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  'Amor em quatro patas.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontSize: compacto ? 24 : 28),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'Mude uma vida hoje. Milhares de pets estão esperando por um novo lar.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: compacto ? 15 : 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        _EntradaSuave(
                          progresso: base,
                          deslocamento: 30,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 340),
                            child: Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                      ).push(_rotaDashboard());
                                    },
                                    child: Ink(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: compacto ? 16 : 18,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            corPrimaria,
                                            corPrimariaEscura,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x24FF8F2B),
                                            blurRadius: 24,
                                            offset: Offset(0, 14),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Encontrar meu pet',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: compacto ? 17 : 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Feito com amor por AdoPet',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Route<void> _rotaDashboard() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 360),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DashboardPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final deslocamento = Tween<Offset>(
        begin: const Offset(0.12, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final opacidade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      return FadeTransition(
        opacity: opacidade,
        child: SlideTransition(position: deslocamento, child: child),
      );
    },
  );
}

class _EntradaSuave extends StatelessWidget {
  final double progresso;
  final double deslocamento;
  final Widget child;

  const _EntradaSuave({
    required this.progresso,
    required this.deslocamento,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, deslocamento * (1 - progresso)),
      child: Opacity(opacity: progresso, child: child),
    );
  }
}

class _CoracaoFlutuante extends StatefulWidget {
  final bool compacto;

  const _CoracaoFlutuante({required this.compacto});

  @override
  State<_CoracaoFlutuante> createState() => _CoracaoFlutuanteState();
}

class _CoracaoFlutuanteState extends State<_CoracaoFlutuante>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _movimento;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _movimento = Tween<double>(
      begin: 0,
      end: -6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _movimento,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _movimento.value),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.all(widget.compacto ? 10 : 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4E6),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14EF4444),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          Icons.favorite_rounded,
          size: widget.compacto ? 20 : 24,
          color: const Color(0xFFEF4444),
        ),
      ),
    );
  }
}

double _entrada(double valor, double inicio, double fim) {
  final normalizado = ((valor - inicio) / (fim - inicio)).clamp(0.0, 1.0);
  return Curves.easeOutCubic.transform(normalizado);
}
