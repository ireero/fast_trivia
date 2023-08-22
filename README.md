# Fast Trivia Flutter App

Este é um aplicativo Flutter para questionários de trivia rápido.

## Funcionalidades Principais

O aplicativo possui as seguintes funcionalidades principais:

1. Iniciar Quiz: Você pode iniciar um novo questionário.
2. Responder Perguntas: Responda a perguntas de trivia uma por uma.
3. Ver Resultados: Visualize os resultados após concluir o questionário.
4. Listar Respostas: Veja uma lista de questionários concluídos.

## Telas do Aplicativo

O aplicativo possui várias telas:

- **StartScreen**: Tela inicial que permite iniciar um novo questionário.
- **QuestionsScreen**: Tela para responder perguntas de trivia.
- **ResultsScreen**: Tela que exibe os resultados do questionário.
- **ListAnswerScreen**: Tela que lista os questionários concluídos.

## Classes Principais

- **Quiz**: Gerencia o fluxo do aplicativo, incluindo as telas de questionário e resultados.
- **QuestionsScreen**: Exibe e gerencia a resposta a perguntas de trivia.
- **ResultsScreen**: Mostra os resultados do questionário e permite salvar as respostas.
- **ListAnswerScreen**: Lista os questionários concluídos e exibe detalhes quando selecionados.

## Banco de Dados

- **DatabaseHelper**: Gerencia o armazenamento das respostas dos questionários no SQLite.

## API Mock

- **ApiMock**: Simula uma API que busca perguntas de trivia.

## Requisitos

Para executar o aplicativo, você precisa ter o Flutter e o Dart instalados em seu ambiente de desenvolvimento.

## Como Executar

1. Clone o repositório para sua máquina.
2. Abra o terminal na pasta do projeto.
3. Execute `flutter run` para iniciar o aplicativo.
