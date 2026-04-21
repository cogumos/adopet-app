# AdoPet

Aplicativo mobile desenvolvido em Flutter com foco em descoberta e adoção de animais. O projeto entrega uma experiência visual para navegação por pets, consulta de detalhes, autenticação local, gerenciamento de perfil e acompanhamento inicial da jornada de adoção.

## Para que serve
<p align="center">
<img src="https://github.com/user-attachments/assets/09ce0b7c-0ecf-47bb-aaa9-2379ef2c0a5d" width="300" alt="Detalhes do Pet" />
</p>
O AdoPet foi pensado para aproximar pessoas interessadas em adotar de abrigos, ONGs e tutores. Na implementação atual, ele funciona como um MVP/protótipo funcional com fluxo de navegação completo e persistência local da conta do usuário.

O app permite:

- visualizar pets disponíveis por categoria
- pesquisar por nome ou raça
- abrir a ficha detalhada de cada animal
- acessar favoritos e mensagens
- criar conta, entrar e manter sessão no aparelho
- editar perfil e preferências do aplicativo

## Status do projeto

O projeto já possui interface navegável e recursos de experiência do usuário, mas ainda não conta com backend real.

- catálogo de pets, favoritos, conversas e histórico usam dados mockados no código
- o cadastro é local e armazenado no dispositivo
- o botão de adoção registra apenas uma ação visual via `SnackBar`
- o app está estruturado hoje para Android

## Funcionalidades implementadas

### Experiência principal

- tela inicial com animações e acesso ao dashboard
- dashboard com busca textual, filtros por categoria e navegação inferior
- exibição de localização aproximada do usuário por IP, com opção para ocultar
- tela de detalhe do pet com galeria de imagens, resumo, informações de saúde e dados do doador

### Conta e perfil
<p align="center">
<img src="https://github.com/user-attachments/assets/330c1b6b-350c-4c6f-9190-5f82b3ad5609" width="300" alt="Dashboard e Listagem" />
</p>

- cadastro e login local
- persistência de sessão entre aberturas do app
- edição de nome do usuário
- troca de foto de perfil pela galeria
- configurações de notificações, localização aproximada e modo tela cheia

### Áreas complementares

- favoritos com cards demonstrativos de pets salvos
- mensagens com conversas simuladas com abrigos e tutores
- seções auxiliares demonstrativas de meus animais, histórico de adoção, ajuda e suporte
- notificações locais para eventos relacionados à conta

## Stack e tecnologias
<p align="center">
<img src="https://github.com/user-attachments/assets/e81d24a9-e853-44f5-9850-5115ae0b6388" width="400" alt="Home do AdoPet" />
</p>

- Flutter
- Dart (`sdk: ^3.11.4`)
- Material 3
- Android com Kotlin e Gradle Kotlin DSL
- Java 17 com desugaring habilitado no build Android

### Dependências principais

- `shared_preferences`: persistência local da conta e do status de sessão
- `image_picker`: seleção de foto de perfil a partir da galeria
- `flutter_local_notifications`: notificações locais no Android

### Recursos nativos e externos

- `dart:io` `HttpClient` para consulta de localização aproximada em `https://ipwho.is/`
- `dart:convert` para serialização e desserialização JSON
- imagens remotas carregadas por URL, majoritariamente via Unsplash

## Arquitetura atual

<p align="center">
  <video src="https://github.com/user-attachments/assets/e5911d34-bb89-41f0-913b-fdb344aa2393" width="500" controls muted autoplay loop>
    Seu navegador não suporta a tag de vídeo.
  </video>
</p>

O projeto segue uma estrutura simples, orientada por telas, com estado local e um controlador central para autenticação.

### Inicialização

- `lib/main.dart`
  - inicializa o Flutter
  - carrega o estado de autenticação
  - inicializa o serviço de notificações
  - trava a orientação em retrato
  - configura o modo de interface do sistema com base na preferência salva

### Estado e autenticação

- `lib/auth_controller.dart`
  - concentra o estado da conta e da sessão
  - usa `ChangeNotifier` + `InheritedNotifier` (`AppAuthScope`) para disponibilizar autenticação no app
  - persiste os dados da conta em `SharedPreferences`

Observação técnica:

- a conta é salva como JSON local
- a senha também é mantida localmente
- esse modelo atende ao protótipo atual, mas não é adequado para produção sem backend e armazenamento seguro

### Módulos de interface

- `lib/home_page.dart`: landing page e entrada para o app
- `lib/dashboard_page.dart`: catálogo, categorias, busca, localização e navegação principal
- `lib/pet_detail_page.dart`: detalhes do animal e CTA de adoção
- `lib/profile_page.dart`: fluxo de login/cadastro e resumo do perfil
- `lib/profile_sections_page.dart`: configurações, ajuda, histórico e páginas auxiliares
- `lib/favorites_page.dart`: lista demonstrativa de favoritos
- `lib/chat_page.dart`: lista e detalhe de conversas simuladas
- `lib/notification_service.dart`: encapsula notificações locais

### Fonte de dados

Hoje o app não possui camada de API, repositório ou banco local estruturado. Os dados são distribuídos diretamente em listas estáticas dentro de arquivos como:

- `lib/dashboard_page.dart`
- `lib/favorites_page.dart`
- `lib/chat_page.dart`
- `lib/pet_detail_page.dart`
- `lib/profile_sections_page.dart`

## Estrutura do projeto

```text
adopet/
|- lib/
|  |- main.dart
|  |- auth_controller.dart
|  |- home_page.dart
|  |- dashboard_page.dart
|  |- pet_detail_page.dart
|  |- favorites_page.dart
|  |- chat_page.dart
|  |- profile_page.dart
|  |- profile_sections_page.dart
|  |- notification_service.dart
|- android/
|- pubspec.yaml
|- README.md
```

## Como executar

### Pré-requisitos

- Flutter SDK compatível com Dart `^3.11.4`
- Android Studio ou Android SDK configurado
- Java 17
- emulador Android ou dispositivo físico

### Instalação

```bash
flutter pub get
```

### Execução em modo de desenvolvimento

```bash
flutter run
```

### Geração de APK

```bash
flutter build apk --release
```

## Permissões e comportamento em tempo de execução

- `INTERNET`: necessária para carregar imagens remotas e consultar localização aproximada
- notificações: solicitadas em tempo de execução quando o usuário ativa ou recebe eventos do app
- acesso à galeria: usado pelo seletor de imagem para foto de perfil

## Dependências de rede

O comportamento atual do app depende de serviços externos para algumas experiências:

- `ipwho.is`: resolve cidade/região aproximada por IP
- URLs de imagem externas: utilizadas nas listagens e telas de detalhe

Se esses recursos estiverem indisponíveis, o app apresenta fallback visual ou textual em partes da interface.

## Limitações técnicas atuais

- não existe backend para autenticação, catálogo, favoritos ou chat em tempo real
- favoritos, mensagens, histórico e "meus animais" são dados demonstrativos
- a conta do usuário fica armazenada localmente no dispositivo
- não há criptografia de credenciais
- o repositório não possui suíte de testes automatizados
- o projeto não inclui, neste estado, estrutura pronta para iOS, web ou desktop

## Próximos passos recomendados

- integrar backend real para autenticação e catálogo de pets
- mover credenciais para armazenamento seguro e fluxo autenticado por token
- separar dados mockados em camada de repositório/serviço
- persistir favoritos e conversas por usuário
- adicionar testes de widget e testes de integração
- preparar suporte multiplataforma, se fizer sentido para o produto

## Resumo técnico

O AdoPet é um aplicativo Flutter orientado a interface e experiência do usuário, com arquitetura simples e adequada para demonstração de fluxo. Ele já entrega navegação, persistência local de conta, notificações, personalização de perfil e apresentação de pets, servindo como base sólida para evoluir para uma aplicação conectada a serviços reais.
