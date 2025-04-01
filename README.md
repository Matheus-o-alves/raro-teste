# Projeto de Testes do Módulo de Pagamentos

Este repositório contém o teste técnico proposto pelo Raro Labs

## Estrutura do Projeto

```
lib/
├── src/
│   ├── core/
│   │   ├── base/
│   │   ├── error/
│   │   └── utils/
│   └── modules/
│       └── payments/
│           ├── data/
│           │   ├── datasource/
│           │   └── repository/
│           ├── domain/
│           │   ├── entity/
│           │   ├── repository/
│           │   └── usecase/
│           └── presentation/
│               ├── bloc/
│               └── page/
test/
├── src/
│   └── modules/
│       └── payments/
│           ├── data/
│           ├── domain/
│           └── presentation/
│               ├── bloc/
│               └── page/
│           ├── mock/
│

## Pré-requisitos

- Flutter (versão 3.29.0, ou superior)
- Dart (versão 3.0.0 ou superior)
- IDE: Android Studio, VS Code ou outra IDE compatível com Flutter

## Como Configurar o Projeto

1. Clone o repositório:
   git clone https://github.com/Matheus-o-alves/raro-teste.git
   cd raro-teste
   ```

2. Instale as dependências:
   flutter pub get
   ```

3. Gere os arquivos de mock necessários para os testes:
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Como Executar os Testes

### Executar Todos os Testes


flutter test
```

### Executar Testes Específicos


# Executar testes do módulo de pagamentos
flutter test test/src/modules/payments/

# Executar testes do BLoC de pagamentos
flutter test test/src/modules/payments/presentation/bloc/payments_bloc_test.dart

# Executar testes do repositório de pagamentos
flutter test test/src/modules/payments/data/repository/payments_repository_impl_test.dart
```

### Executar Testes com Cobertura


flutter test --coverage
```

Para visualizar o relatório de cobertura em HTML (requer o pacote `lcov`):


genhtml coverage/lcov.info -o coverage/html
```

Depois, abra `coverage/html/index.html` no seu navegador.

## Implementações Testadas

O projeto contém testes unitários para:

1. **PaymentsState**: Testes para a classe que mantém o estado do BLoC.
2. **PaymentsEvent**: Testes para os eventos que podem ser disparados no BLoC.
3. **PaymentsBloc**: Testes para o BLoC que gerencia o estado da tela de pagamentos.
4. **DetailRowBuilder**: Testes para a classe que constrói as linhas de detalhes das transações.
5. **PaymentsRepositoryImpl**: Testes para a implementação do repositório que acessa os dados.

## Arquitetura

O projeto segue os princípios de Clean Architecture:

- **Camada de Domínio**: Contém entidades, interfaces de repositório e casos de uso.
- **Camada de Dados**: Contém implementações de repositório e fontes de dados.
- **Camada de Apresentação**: Contém BLoCs e componentes de UI.

## Tratamento de Erros

O projeto implementa um tratamento de erros robusto:

- Uso do tipo `Either` da biblioteca dartz para representar sucesso ou falha.
- Classes de falha bem definidas para diferentes tipos de erro.
- Tratamento adequado de exceções em cada camada.

## Melhores Práticas Implementadas

- **Testes Isolados**: Cada teste é independente e não afeta outros testes.
- **Mocks**: Uso de mocks para simular dependências externas.
- **Testes de Limite**: Testes para cenários de sucesso e falha.
- **Organização**: Testes agrupados de forma lógica.
- **Legibilidade**: Nomes de testes descritivos e bem organizados.


5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.