# AdoPet

> Aplicativo mobile em Flutter e Dart para descoberta e adoção de animais, com busca, perfil, favoritos, mensagens e recursos voltados à experiência do usuário.

O projeto funciona como um **MVP mobile** e também como laboratório de **Quality Engineering em Flutter**, combinando desenvolvimento de interface, persistência local e testes automatizados.

`// explorar. interagir. validar.`

<p align="center">
  <img src="https://github.com/user-attachments/assets/e81d24a9-e853-44f5-9850-5115ae0b6388" width="620" alt="Home do AdoPet" />
</p>


## >_ demonstração

<p align="center">
  <video src="https://github.com/user-attachments/assets/42c1d6be-3c98-4ec6-acc7-9a8f85ac325b" width="700" controls muted autoplay loop>
    Seu navegador não suporta a tag de vídeo.
  </video>
</p>


## >_ telas do app

<p align="center">
  <img src="https://github.com/user-attachments/assets/330c1b6b-350c-4c6f-9190-5f82b3ad5609" width="700" alt="Dashboard e Listagem" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/1e97fdba-5856-41f3-8db3-a30f7f3e1640" width="700" alt="Detalhes do Pet" />
</p>


## >_ o que ele faz

- exibe pets por categorias e permite busca por nome ou raça;
- apresenta ficha detalhada com imagens, informações de saúde e dados do doador;
- possui cadastro, login e persistência local da sessão;
- permite editar nome e foto do perfil;
- oferece favoritos e conversas demonstrativas;
- utiliza notificações locais;
- exibe localização aproximada com opção para desativar;
- possui configurações de experiência e interface.


## >_ qualidade e testes

O projeto possui testes automatizados voltados tanto à lógica quanto ao comportamento da interface.

```text
41 testes
├── 31 unitários
└── 10 de widget / integração
```

A suíte valida regras internas, estado da aplicação, componentes de interface e fluxos importantes do aplicativo.

Execute os testes com:

```bash
flutter test
```


## >_ escopo atual

O AdoPet é um **MVP funcional**. Nesta versão:

- catálogo, favoritos, mensagens e histórico utilizam dados demonstrativos;
- cadastro e sessão são persistidos localmente no dispositivo;
- ainda não existe backend real para autenticação e catálogo;
- o fluxo de adoção atual é demonstrativo;
- a implementação está direcionada ao Android.

Essas decisões permitem concentrar o projeto na experiência mobile, navegação, estado local e validação da aplicação.


## >_ como executar

Pré-requisitos:

- Flutter SDK compatível com Dart `^3.11.4`;
- Android SDK ou Android Studio;
- Java 17;
- emulador Android ou dispositivo físico.

Clone o projeto:

```bash
git clone https://github.com/cogumos/adopet-app.git
cd adopet-app/adopet
```

Instale as dependências:

```bash
flutter pub get
```

Execute:

```bash
flutter run
```

Para gerar um APK:

```bash
flutter build apk --release
```


## >_ stack

`Flutter` `Dart` `Material 3` `Android` `Kotlin` `SharedPreferences` `Flutter Local Notifications`

**Foco:** `Mobile Testing` `Unit Testing` `Widget Testing` `Integration Testing` `Quality Engineering` `UX`
