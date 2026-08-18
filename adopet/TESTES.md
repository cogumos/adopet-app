# Testes — AdoPet

Nenhum arquivo de `lib/` foi alterado. O aplicativo continua exatamente o que
era; o que entrou foi a camada de teste que faltava, mais as
`dev_dependencies` obrigatórias no `pubspec.yaml`.

## Estrutura

```
test/auth_controller_test.dart          unidade — roda sem aparelho
integration_test/fluxo_app_test.dart    integração — roda no emulador/aparelho
```

## Execução

```bash
flutter pub get
flutter test                                        # unidade
flutter test integration_test/fluxo_app_test.dart   # integração
```

## `test/auth_controller_test.dart` — 30 testes de unidade

`SharedPreferences` é substituído por um mock em memória, então nenhum teste
toca dado real do aparelho. O foco são as regras que decidem se alguém entra ou
não no aplicativo.

| Grupo | Cobre |
|---|---|
| Cadastro — validações | nome vazio, e-mail sem arroba, sem domínio, com espaço; senha curta e senha só de espaços; limite exato de 6 caracteres |
| Cadastro — normalização | espaços removidos, e-mail em minúsculas, cadastro **não** autentica sozinho |
| `primeiroNome` | nome composto, espaços múltiplos, reserva `'Humano'` quando vazio |
| Login | senha errada, e-mail errado, credenciais corretas, e-mail em maiúsculas aceito, **senha continua sensível a maiúsculas** |
| Sair | encerra sessão sem apagar a conta |
| Atualizar nome | recusa vazio, recusa sem conta, propaga para a sessão ativa |
| Persistência | conta sobrevive ao reinício, sessão restaurada quando marcada, **dado corrompido não derruba o app** |
| Notificação | ouvintes avisados no cadastro; `sair()` sem sessão não notifica |

Os testes de dado corrompido merecem destaque: `initialize()` faz `jsonDecode`
do que estiver salvo no aparelho. Se aquilo virar lixo — atualização
interrompida, aplicativo forçado a fechar — o app precisa abrir mesmo assim, e
não numa tela branca.

## `integration_test/fluxo_app_test.dart` — 10 testes de integração

Sobem a árvore de widgets de verdade e verificam que o app abre, respeita o
estado de sessão salvo e reage à navegação.

São propositalmente **resistentes a mudança de layout**: verificam
comportamento (o app abriu, a sessão foi respeitada, o toque não lançou
exceção), não posição de botão nem texto decorativo. Teste de integração que
quebra a cada ajuste visual vira teste que ninguém roda.

## Aviso de execução

Estes testes foram escritos a partir da leitura do código, mas **não foram
executados** — a máquina onde foram criados não tem o SDK do Flutter instalado.
Rode `flutter test` antes de publicar. Ajustes de nome de import ou de
assinatura, se aparecerem, são rápidos.
