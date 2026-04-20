import 'package:flutter/material.dart';

import 'main.dart';

class PetDetalhePage extends StatefulWidget {
  final PetDetalhe detalhe;

  const PetDetalhePage({super.key, required this.detalhe});

  @override
  State<PetDetalhePage> createState() => _PetDetalhePageState();
}

class _PetDetalhePageState extends State<PetDetalhePage> {
  int fotoAtual = 0;

  void _adotarAgora() {
    final detalhe = widget.detalhe;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Interesse enviado para ${detalhe.doador}.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tamanho = MediaQuery.sizeOf(context);
    final compacto = tamanho.height < 760 || tamanho.width < 380;
    final detalhe = widget.detalhe;

    return Scaffold(
      backgroundColor: corFundoApp,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: compacto ? 400 : 448,
                pinned: true,
                backgroundColor: corFundoBase,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: corTextoForte,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share_rounded,
                          color: corTextoForte,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFEF4444),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: detalhe.fotos.length,
                        onPageChanged: (index) {
                          setState(() {
                            fotoAtual = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            detalhe.fotos[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFFFEDD5),
                                alignment: Alignment.center,
                                child: const Text(
                                  '🐾',
                                  style: TextStyle(fontSize: 84),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x18000000), Color(0xC20F172A)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: compacto ? 126 : 142,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(detalhe.fotos.length, (
                            index,
                          ) {
                            final ativo = index == fotoAtual;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: ativo ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: ativo
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: compacto ? 30 : 38,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detalhe.nome,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontSize: compacto ? 30 : 34,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              detalhe.raca,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontSize: compacto ? 16 : 17,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _ChipDetalhe(
                                  rotulo: detalhe.idade,
                                  icone: Icons.schedule_rounded,
                                ),
                                _ChipDetalhe(
                                  rotulo: detalhe.peso,
                                  icone: Icons.monitor_weight_rounded,
                                ),
                                _ChipDetalhe(
                                  rotulo: detalhe.vacinacao,
                                  icone: Icons.verified_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, compacto ? 128 : 140),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumo rápido',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF24324A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _GradeInformacoes(
                        itens: [
                          _InfoDetalheItem(
                            titulo: 'Idade',
                            valor: detalhe.idade,
                            icone: Icons.cake_rounded,
                            corFundo: const Color(0xFFFFF5EC),
                            corIcone: corPrimariaEscura,
                          ),
                          _InfoDetalheItem(
                            titulo: 'Peso',
                            valor: detalhe.peso,
                            icone: Icons.monitor_weight_rounded,
                            corFundo: const Color(0xFFF1F5FB),
                            corIcone: const Color(0xFF4F46E5),
                          ),
                          _InfoDetalheItem(
                            titulo: 'Vacinação',
                            valor: detalhe.vacinacao,
                            icone: Icons.health_and_safety_rounded,
                            corFundo: const Color(0xFFEEF8F1),
                            corIcone: const Color(0xFF16A34A),
                          ),
                          _InfoDetalheItem(
                            titulo: 'Distância',
                            valor: detalhe.distancia,
                            icone: Icons.location_on_rounded,
                            corFundo: const Color(0xFFFFF1F1),
                            corIcone: const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Sobre o animal',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF24324A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x100F172A),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Text(
                          detalhe.descricao,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF62748D),
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Quem está doando',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF24324A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x100F172A),
                              blurRadius: 24,
                              offset: Offset(0, 12),
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
                                color: const Color(0xFFFFF1E6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.volunteer_activism_rounded,
                                color: corPrimariaEscura,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detalhe.doador,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: const Color(0xFF24324A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    detalhe.tipoDoador,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: corPrimariaEscura,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    detalhe.localizacao,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF62748D),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Mais detalhes',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF24324A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _GradeInformacoes(
                        itens: [
                          _InfoDetalheItem(
                            titulo: 'Gênero',
                            valor: detalhe.genero,
                            icone: Icons.pets_rounded,
                            corFundo: const Color(0xFFFDF2F8),
                            corIcone: const Color(0xFFDB2777),
                          ),
                          _InfoDetalheItem(
                            titulo: 'Porte',
                            valor: detalhe.porte,
                            icone: Icons.straighten_rounded,
                            corFundo: const Color(0xFFF1F5FB),
                            corIcone: const Color(0xFF2563EB),
                          ),
                          _InfoDetalheItem(
                            titulo: 'Energia',
                            valor: detalhe.energia,
                            icone: Icons.bolt_rounded,
                            corFundo: const Color(0xFFFFF5EC),
                            corIcone: corPrimariaEscura,
                          ),
                          _InfoDetalheItem(
                            titulo: 'Saúde',
                            valor: detalhe.saude,
                            icone: Icons.favorite_rounded,
                            corFundo: const Color(0xFFEEF8F1),
                            corIcone: const Color(0xFF16A34A),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120F172A),
                      blurRadius: 30,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: FilledButton.icon(
                  onPressed: _adotarAgora,
                  style: FilledButton.styleFrom(
                    backgroundColor: corPrimaria,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  icon: const Icon(Icons.pets_rounded),
                  label: Text(
                    'Adote agora',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipDetalhe extends StatelessWidget {
  final String rotulo;
  final IconData icone;

  const _ChipDetalhe({required this.rotulo, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            rotulo,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeInformacoes extends StatelessWidget {
  final List<_InfoDetalheItem> itens;

  const _GradeInformacoes({required this.itens});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final umaColuna = constraints.maxWidth < 340;
        final larguraCard = umaColuna
            ? constraints.maxWidth
            : (constraints.maxWidth - 14) / 2;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: itens
              .map(
                (item) => SizedBox(
                  width: larguraCard,
                  child: _CardInfoDetalhe(
                    titulo: item.titulo,
                    valor: item.valor,
                    icone: item.icone,
                    corFundo: item.corFundo,
                    corIcone: item.corIcone,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _CardInfoDetalhe extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color corFundo;
  final Color corIcone;

  const _CardInfoDetalhe({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.corFundo,
    required this.corIcone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: corFundo,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icone, color: corIcone),
          ),
          const SizedBox(height: 14),
          Text(
            titulo,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8A9BB6),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(0xFF24324A),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDetalheItem {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color corFundo;
  final Color corIcone;

  const _InfoDetalheItem({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.corFundo,
    required this.corIcone,
  });
}

class PetDetalhe {
  final String nome;
  final String raca;
  final String idade;
  final String genero;
  final String imagem;
  final List<String> fotos;
  final String descricao;
  final String doador;
  final String tipoDoador;
  final String localizacao;
  final String distancia;
  final String porte;
  final String energia;
  final String saude;
  final String peso;
  final String vacinacao;

  const PetDetalhe({
    required this.nome,
    required this.raca,
    required this.idade,
    required this.genero,
    required this.imagem,
    required this.fotos,
    required this.descricao,
    required this.doador,
    required this.tipoDoador,
    required this.localizacao,
    required this.distancia,
    required this.porte,
    required this.energia,
    required this.saude,
    required this.peso,
    required this.vacinacao,
  });
}

PetDetalhe detalhePet({
  required int id,
  required String nome,
  required String raca,
  required String idade,
  required String imagem,
  String? genero,
  String? distancia,
}) {
  switch (id) {
    case 1:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '1,5 km',
        descricao:
            'Bidu é um companheiro dócil, adora passeios leves, brincadeiras com bolinha e fica feliz perto de pessoas. Já conviveu com crianças e está pronto para entrar em um novo lar com bastante afeto.',
        doador: 'Abrigo Patas Felizes',
        tipoDoador: 'Abrigo parceiro',
        localizacao: 'Vila Mariana, São Paulo - SP',
        porte: 'Porte médio',
        energia: 'Equilibrada',
        saude: 'Exames em dia',
        peso: '28 kg',
        vacinacao: 'Vacinado',
      );
    case 2:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '3,2 km',
        descricao:
            'Luna é uma gatinha curiosa, tranquila e muito carinhosa. Gosta de ambientes calmos, prateleiras altas e momentos de descanso perto de quem cuida dela.',
        doador: 'Associação Miados',
        tipoDoador: 'ONG de resgate',
        localizacao: 'Pinheiros, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Suave',
        saude: 'Castrada',
        peso: '3,4 kg',
        vacinacao: 'Vacinada',
      );
    case 3:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '0,8 km',
        descricao:
            'Rex é atento, inteligente e muito fiel. Já passou por socialização com outros cães e responde bem a comandos simples, sendo ideal para quem busca um amigo protetor.',
        doador: 'Canil Municipal',
        tipoDoador: 'Resgate público',
        localizacao: 'Santana, São Paulo - SP',
        porte: 'Porte grande',
        energia: 'Alta',
        saude: 'Vermifugado',
        peso: '34 kg',
        vacinacao: 'Vacinado',
      );
    case 4:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '5,0 km',
        descricao:
            'Mel é brincalhona, sociável e ama companhia. Tem perfil excelente para famílias, gosta de explorar novos cheiros e fica animada em ambientes acolhedores.',
        doador: 'Lar Temporário da Ana',
        tipoDoador: 'Tutora voluntária',
        localizacao: 'Mooca, São Paulo - SP',
        porte: 'Porte médio',
        energia: 'Alta',
        saude: 'Castrada',
        peso: '13 kg',
        vacinacao: 'Vacinada',
      );
    case 5:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '2,1 km',
        descricao:
            'Floquinho gosta de colo, rotina tranquila e carinhos constantes. É um pet ideal para quem quer companhia no dia a dia e um ritmo mais sereno dentro de casa.',
        doador: 'Projeto Adota Amor',
        tipoDoador: 'Protetor independente',
        localizacao: 'Saúde, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Moderada',
        saude: 'Castrado',
        peso: '8 kg',
        vacinacao: 'Vacinado',
      );
    case 6:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '1,1 km',
        descricao:
            'Nina é delicada, observadora e adora uma manta macia para descansar. Tem adaptação fácil em apartamento e procura um lar com atenção e calma.',
        doador: 'Casa dos Gatinhos',
        tipoDoador: 'Abrigo felino',
        localizacao: 'Bela Vista, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Suave',
        saude: 'Castrada',
        peso: '4 kg',
        vacinacao: 'Vacinada',
      );
    case 7:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '2,4 km',
        descricao:
            'Theo é alegre, companheiro e muito receptivo a novas amizades. Gosta de brincadeiras curtas, contato humano e passeios ao ar livre.',
        doador: 'Instituto Caramelo',
        tipoDoador: 'Rede de acolhimento',
        localizacao: 'Tatuapé, São Paulo - SP',
        porte: 'Porte médio',
        energia: 'Alta',
        saude: 'Vermifugado',
        peso: '16 kg',
        vacinacao: 'Vacinado',
      );
    case 8:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '4,1 km',
        descricao:
            'Amora tem um jeitinho elegante e afetuoso. É curiosa, gosta de observar tudo ao redor e costuma criar vínculo rápido com quem demonstra paciência.',
        doador: 'Miados Urbanos',
        tipoDoador: 'ONG parceira',
        localizacao: 'Consolação, São Paulo - SP',
        porte: 'Porte médio',
        energia: 'Moderada',
        saude: 'Castrada',
        peso: '5,6 kg',
        vacinacao: 'Vacinada',
      );
    case 9:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '3,8 km',
        descricao:
            'Kiwi é uma ave ativa e curiosa, gosta de interação suave e de um ambiente enriquecido. Ideal para quem deseja companhia leve e alegre.',
        doador: 'Viveiro Esperança',
        tipoDoador: 'Resgate especializado',
        localizacao: 'Ipiranga, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Alta',
        saude: 'Acompanhamento veterinário',
        peso: '90 g',
        vacinacao: 'Em avaliação',
      );
    case 10:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '2,9 km',
        descricao:
            'Sol tem canto suave, energia tranquila e boa adaptação a ambientes bem cuidados. É uma companhia encantadora para rotinas serenas.',
        doador: 'Aves em Casa',
        tipoDoador: 'Cuidadora voluntária',
        localizacao: 'Lapa, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Moderada',
        saude: 'Acompanhamento veterinário',
        peso: '35 g',
        vacinacao: 'Em avaliação',
      );
    case 11:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '1,7 km',
        descricao:
            'Pipoca é dócil, gosta de ambientes tranquilos e se adapta bem à rotina de casa. Ama petiscos naturais, tocas confortáveis e contato respeitoso.',
        doador: 'Cantinho do Coelho',
        tipoDoador: 'Lar temporário',
        localizacao: 'Aclimação, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Suave',
        saude: 'Vermifugada',
        peso: '1,8 kg',
        vacinacao: 'Em avaliação',
      );
    case 12:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '4,8 km',
        descricao:
            'Cacau é curioso, tranquilo e adora explorar com segurança. É indicado para quem quer um animal de companhia com rotina leve e muito carinho.',
        doador: 'Resgate Orelhinhas',
        tipoDoador: 'ONG parceira',
        localizacao: 'Sacomã, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Moderada',
        saude: 'Vermifugado',
        peso: '2,1 kg',
        vacinacao: 'Em avaliação',
      );
    case 13:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '900 m',
        descricao:
            'Maya é carinhosa, leve e muito apegada às pessoas. Gosta de colo, rotina previsível e passeios curtos, sendo ótima para apartamentos.',
        doador: 'Rede Pet com Amor',
        tipoDoador: 'Tutora voluntária',
        localizacao: 'Paraíso, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Moderada',
        saude: 'Castrada',
        peso: '7 kg',
        vacinacao: 'Vacinada',
      );
    case 14:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '2,0 km',
        descricao:
            'Tom é observador, elegante e gosta de se aproximar no próprio tempo. Quando cria confiança, fica muito companheiro e adora lugares confortáveis.',
        doador: 'Refúgio dos Felinos',
        tipoDoador: 'Abrigo parceiro',
        localizacao: 'Perdizes, São Paulo - SP',
        porte: 'Porte médio',
        energia: 'Suave',
        saude: 'Castrado',
        peso: '4,8 kg',
        vacinacao: 'Vacinado',
      );
    case 15:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Macho',
        imagem: imagem,
        distancia: distancia ?? '3,5 km',
        descricao:
            'Bento é um cão cheio de personalidade, divertido e muito ligado à rotina da casa. Ama carinho, passeios e responde muito bem ao contato humano.',
        doador: 'Casa do Caramelo',
        tipoDoador: 'Abrigo parceiro',
        localizacao: 'Vila Prudente, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Alta',
        saude: 'Exames em dia',
        peso: '11 kg',
        vacinacao: 'Vacinado',
      );
    case 16:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Fêmea',
        imagem: imagem,
        distancia: distancia ?? '5,2 km',
        descricao:
            'Lili é delicada, curiosa e animada. Gosta de ambientes claros, interação suave e rotina estável, trazendo leveza para quem convive com ela.',
        doador: 'Projeto Aves Livres',
        tipoDoador: 'Resgate especializado',
        localizacao: 'Vila Clementino, São Paulo - SP',
        porte: 'Porte pequeno',
        energia: 'Alta',
        saude: 'Acompanhamento veterinário',
        peso: '45 g',
        vacinacao: 'Em avaliação',
      );
    default:
      return _montarPetDetalhe(
        id: id,
        nome: nome,
        raca: raca,
        idade: idade,
        genero: genero ?? 'Não informado',
        imagem: imagem,
        distancia: distancia ?? 'Próximo a você',
        descricao:
            'Este animal está disponível para adoção e aguarda uma família com carinho, responsabilidade e vontade de oferecer um novo começo.',
        doador: 'Rede AdoPet',
        tipoDoador: 'Doador parceiro',
        localizacao: 'São Paulo - SP',
        porte: 'Porte não informado',
        energia: 'Moderada',
        saude: 'Acompanhado',
        peso: 'Não informado',
        vacinacao: 'Consultar abrigo',
      );
  }
}

PetDetalhe _montarPetDetalhe({
  required int id,
  required String nome,
  required String raca,
  required String idade,
  required String genero,
  required String imagem,
  required String descricao,
  required String doador,
  required String tipoDoador,
  required String localizacao,
  required String distancia,
  required String porte,
  required String energia,
  required String saude,
  required String peso,
  required String vacinacao,
}) {
  return PetDetalhe(
    nome: nome,
    raca: raca,
    idade: idade,
    genero: genero,
    imagem: imagem,
    fotos: _fotosPet(id, imagem),
    descricao: descricao,
    doador: doador,
    tipoDoador: tipoDoador,
    localizacao: localizacao,
    distancia: distancia,
    porte: porte,
    energia: energia,
    saude: saude,
    peso: peso,
    vacinacao: vacinacao,
  );
}

List<String> _fotosPet(int id, String imagem) {
  switch (id) {
    case 1:
    case 3:
    case 4:
    case 5:
    case 7:
    case 13:
    case 15:
      return {
        imagem,
        'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&q=80&w=1200',
        'https://images.unsplash.com/photo-1525253013412-55c1a69a5738?auto=format&fit=crop&q=80&w=1200',
      }.toList();
    case 2:
    case 6:
    case 8:
    case 14:
      return {
        imagem,
        'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&q=80&w=1200',
        'https://images.unsplash.com/photo-1494256997604-768d1f608cac?auto=format&fit=crop&q=80&w=1200',
      }.toList();
    case 9:
    case 10:
    case 16:
      return {
        imagem,
        'https://images.unsplash.com/photo-1444464666168-49d633b86797?auto=format&fit=crop&q=80&w=1200',
        'https://images.unsplash.com/photo-1452570053594-1b985d6ea890?auto=format&fit=crop&q=80&w=1200',
      }.toList();
    case 11:
    case 12:
      return {
        imagem,
        'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&q=80&w=1200',
        'https://images.unsplash.com/photo-1583301286816-f4f05e1e8b25?auto=format&fit=crop&q=80&w=1200',
      }.toList();
    default:
      return [imagem];
  }
}
