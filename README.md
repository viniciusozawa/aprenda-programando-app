<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0C0A14,50:818CF8,100:E11D48&height=220&section=header&text=Aprenda%20Programa%C3%A7%C3%A3o%20Jogando&fontSize=40&fontColor=FFFFFF&animation=fadeIn&fontAlignY=36&desc=L%C3%B3gica%20de%20programa%C3%A7%C3%A3o%20em%20Portugu%C3%AAs%2C%20de%20forma%20divertida&descAlignY=58&descSize=17" width="100%"/>

<a href="#">
  <img src="https://readme-typing-svg.demolab.com/?font=Fira+Code&weight=600&size=22&duration=3000&pause=900&color=FACC15&center=true&vCenter=true&width=680&lines=Aprenda+l%C3%B3gica+de+programa%C3%A7%C3%A3o+brincando+%F0%9F%8E%AE;Comandos+100%25+em+Portugu%C3%AAs+%F0%9F%87%A7%F0%9F%87%B7;Um+jogo+de+puzzle+para+quem+est%C3%A1+come%C3%A7ando+%F0%9F%A7%A9;Projeto+acad%C3%AAmico+do+IFSULDEMINAS+%F0%9F%8E%93" alt="Typing SVG"/>
</a>

<br/>

![status](https://img.shields.io/badge/status-em%20desenvolvimento%20%F0%9F%9A%80-FACC15?style=for-the-badge&labelColor=0C0A14)
![plataforma](https://img.shields.io/badge/plataforma-Android-34D399?style=for-the-badge&logo=android&logoColor=white&labelColor=0C0A14)
![linguagem](https://img.shields.io/badge/linguagem-Dart-818CF8?style=for-the-badge&logo=dart&logoColor=white&labelColor=0C0A14)
![framework](https://img.shields.io/badge/framework-Flutter-E11D48?style=for-the-badge&logo=flutter&logoColor=white&labelColor=0C0A14)
![licenca](https://img.shields.io/badge/licen%C3%A7a-a%20definir-1C1830?style=for-the-badge&labelColor=0C0A14)

</div>

<br/>

## 📋 Sumário

- [📋 Sumário](#-sumário)
- [🎯 Sobre o Projeto](#-sobre-o-projeto)
- [🧩 O Problema → A Solução](#-o-problema--a-solução)
- [🕹️ Como o Jogo Funciona](#️-como-o-jogo-funciona)
- [📱 Telas Implementadas](#-telas-implementadas)
- [🧠 Conceitos Ensinados](#-conceitos-ensinados)
- [⚙️ Tecnologias](#️-tecnologias)
- [▶️ Como Rodar](#️-como-rodar)
- [📁 Estrutura do Projeto](#-estrutura-do-projeto)
- [📚 Documentação](#-documentação)
- [🎨 Identidade Visual](#-identidade-visual)
- [⭐ Diferenciais](#-diferenciais)
- [🗺️ Roadmap](#️-roadmap)
- [👥 Equipe](#-equipe)
- [🏫 Instituição](#-instituição)

<br/>

## 🎯 Sobre o Projeto

**Aprenda Programação Jogando** é um aplicativo educacional mobile, desenvolvido em **Flutter**, que ensina os fundamentos da **lógica de programação** por meio de um jogo de puzzle interativo.

Ao invés de aulas tradicionais ou código em inglês, o jogador controla um personagem dentro de fases usando comandos simples **em português** — como *andar*, *virar* e *repetir* — testando soluções, errando, corrigindo e aprendendo na prática.

O público-alvo são crianças e adolescentes de **10 a 14 anos**, uma faixa etária que ainda é pouco atendida pelos principais aplicativos do gênero disponíveis hoje no mercado (a maioria em inglês, voltada a crianças menores ou a adultos).

> 💡 A ideia nasceu como projeto acadêmico, mas o objetivo é evoluir para um app público, gratuito e em português para estudantes brasileiros.

<br/>

## 🧩 O Problema → A Solução

<table width="100%">
<tr>
<th align="left">⚠️ O Problema</th>
<th align="left">✅ A Solução</th>
</tr>
<tr valign="top">
<td>

Programação parece difícil para iniciantes:
- Conteúdo majoritariamente em inglês cria barreira
- Apps complexos afastam jovens
- Falta de jogabilidade real no aprendizado

</td>
<td>

**Aprenda Programação Jogando**
- Comandos em português
- Jogo de puzzle interativo, com personagem
- Aprendizado autônomo, sem depender de professor

</td>
</tr>
</table>

<br/>

## 🕹️ Como o Jogo Funciona

| Mecânica | Descrição | Status |
|---|---|---|
| 🧱 **Editor de comandos** | O jogador monta sequências de instruções em português (*andar*, *virar*, *repetir*, *se/senão*) | ✅ andar · virar · repetir |
| ▶️ **Simulador em tempo real** | Um botão "Executar" anima o robô 🤖 passo a passo até a bandeira 🚩 | ✅ |
| 🧗 **Fases progressivas** | Desafios do mais simples ao mais complexo, um conceito novo por fase | ✅ Mundo 1 |
| ⭐ **Sistema de estrelas** | Avaliação de 1 a 3 estrelas conforme a eficiência da solução (menos blocos = mais estrelas) | ✅ |
| 🏅 **Conquistas** | Tela de troféus com estrelas e progresso por mundo | ✅ |
| 🧪 **Modo Livre** | Área sem objetivo fixo para experimentar comandos livremente | 🔜 |

<br/>

## 📱 Telas Implementadas

| # | Tela | Arquivo | O que faz |
|---|---|---|---|
| 1 | 🏠 **Início** | `home_screen.dart` | Logo animado, título e botões "Começar a Jogar" / "Continuar Progresso" |
| 2 | 🌍 **Escolha de Mundo** | `world_select_screen.dart` | 4 mundos (Floresta Mágica, Cidade Futurista, Espaço Profundo, Dimensão Digital) com progresso e bloqueio |
| 3 | 📖 **Tutorial** | `tutorial_screen.dart` | 4 páginas deslizáveis explicando o jogo (aparece na 1ª vez em cada mundo) |
| 4 | 🗺️ **Mapa de Fases** | `phase_map_screen.dart` | Caminho em zigue-zague com fases concluídas, atual (pulsando) e bloqueadas |
| 5 | 🎮 **Jogo** | `game_screen.dart` | Grade 7×5, blocos de comando, execução animada do robô e verificação da solução |
| 6 | 🏆 **Vitória** | `victory_screen.dart` | Troféu, estrelas animadas, confete e opções de próxima fase / tentar de novo |
| 7 | 🥇 **Troféus** | `trophy_screen.dart` | Estatísticas gerais e estrelas de cada fase por mundo |
| 8 | ⚙️ **Configurações** | `settings_screen.dart` | Áudio, resetar progresso, estudos de widgets e informações do app |
| + | 📶 **Estudo: StatusBar** | `screens/statusbar/` | Menu + 2 exemplos: estilo da barra (`AnnotatedRegion`) e visibilidade / modo imersivo (`SystemChrome`) |

```
Início → Escolha de Mundo → Tutorial (1ª vez) → Mapa de Fases → Jogo → Vitória
                 └── barra inferior: Troféus · Configurações → Estudo StatusBar
```

<br/>

## 🧠 Conceitos Ensinados

<div align="center">

![sequencia](https://img.shields.io/badge/Sequ%C3%AAncia-818CF8?style=for-the-badge&labelColor=0C0A14)
![loops](https://img.shields.io/badge/Loops%20(repeti%C3%A7%C3%A3o)-34D399?style=for-the-badge&labelColor=0C0A14)
![condicionais](https://img.shields.io/badge/Condicionais%20(se%2Fsen%C3%A3o)-FACC15?style=for-the-badge&labelColor=0C0A14)
![funcoes](https://img.shields.io/badge/Fun%C3%A7%C3%B5es-F97316?style=for-the-badge&labelColor=0C0A14)
![variaveis](https://img.shields.io/badge/Vari%C3%A1veis-E11D48?style=for-the-badge&labelColor=0C0A14)

</div>

Cada conceito é apresentado de forma gradual — um por bloco de fases — reforçado por textos curtos, vídeos de 30 a 90 segundos, animações e um glossário interativo.

<br/>

## ⚙️ Tecnologias

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)

</div>

O app é desenvolvido em **Flutter** (Dart 3, Material 3), com foco inicial na plataforma **Android**, priorizando um funcionamento 100% mobile — sem necessidade de computador. Não usa pacotes externos além do próprio Flutter.

<br/>

## ▶️ Como Rodar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (`flutter doctor` sem erros).

```bash
git clone https://github.com/viniciusozawa/aprenda-programando-app.git
cd aprenda-programando-app
flutter pub get
flutter run
```

| Comando | O que faz |
|---|---|
| `flutter run` | Abre o jogo |
| `flutter run -t lib/main_statusbar.dart` | Abre direto nos exemplos de StatusBar |
| `flutter test` | Roda os testes automatizados (3 testes) |
| `flutter analyze` | Verifica o código |

<br/>

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # ponto de entrada do jogo
├── main_statusbar.dart       # ponto de entrada dos exemplos de StatusBar
├── theme/app_theme.dart      # paleta Neon Arcade (AppColors) e tema (AppTheme)
├── models/
│   ├── game_models.dart      # Phase, World, CommandBlock + dados dos mundos/fases
│   └── progress.dart         # GameProgress: estrelas e tutoriais vistos
├── widgets/app_widgets.dart  # NeonButton, StarRow, NeonProgressBar, AppBottomNav...
└── screens/                  # as 8 telas do jogo + statusbar/ (estudo da Fase 5)
test/                         # testes de widget
docs/                         # entregas escritas e documentação do código
```

<br/>

## 📚 Documentação

| Documento | Conteúdo |
|---|---|
| [📘 Documentação do Código](docs/DOCUMENTACAO_DO_CODIGO.md) | Todos os arquivos, classes, heranças, lógica do jogo, animações e testes |
| [📄 Fase 4 — Catálogo de Widgets](docs/Fase4_Catalogo_Widgets_Flutter_CodePlayBR.docx) | Catálogo dos widgets Flutter usados no app |
| [📄 Fase 5 — Pesquisa StatusBar](docs/Fase5_Pesquisa_StatusBar_CodePlayBR.docx) | Pesquisa sobre a barra de status e os dois exemplos implementados |

<br/>

## 🎨 Identidade Visual

Paleta de cores definida para o projeto — **"Neon Arcade"**, inspirada em estética retrô/fliperama:

| Cor | Hex | Uso |
|---|---|---|
| ![](https://img.shields.io/badge/-%20-0C0A14?style=for-the-badge) | `#0C0A14` | Fundo |
| ![](https://img.shields.io/badge/-%20-1C1830?style=for-the-badge) | `#1C1830` | Superfície |
| ![](https://img.shields.io/badge/-%20-E11D48?style=for-the-badge) | `#E11D48` | Rosa / vermelho (destaque) |
| ![](https://img.shields.io/badge/-%20-F97316?style=for-the-badge) | `#F97316` | Laranja |
| ![](https://img.shields.io/badge/-%20-FACC15?style=for-the-badge) | `#FACC15` | Amarelo (acerto/conquista) |
| ![](https://img.shields.io/badge/-%20-34D399?style=for-the-badge) | `#34D399` | Verde (acerto) |
| ![](https://img.shields.io/badge/-%20-818CF8?style=for-the-badge) | `#818CF8` | Índigo |
| ![](https://img.shields.io/badge/-%20-FFFFFF?style=for-the-badge) | `#FFFFFF` | Texto |

<br/>

## ⭐ Diferenciais

| # | Diferencial | Descrição |
|---|---|---|
| 01 | 🇧🇷 **Comandos em Português** | Única proposta com linguagem em PT-BR voltada a iniciantes brasileiros |
| 02 | 🎯 **Público certo: 10–14 anos** | Preenche o espaço entre apps para crianças pequenas e apps de código real |
| 03 | 📱 **100% Mobile** | Nativo em Flutter, direto no celular |
| 04 | 🆓 **Autônomo e Gratuito** | Sem professor obrigatório, sem assinatura |
| 05 | 🎮 **Puzzle com Personagem** | Feedback visual imediato de acerto e erro |

<br/>

## 🗺️ Roadmap

- [x] **Fase 1** — Definição do tema, equipe e professor orientador
- [x] **Fase 2** — Pesquisa de mercado e planejamento de conteúdo
- [x] **Fase 3** — Protótipo do app em Flutter
- [x] **Fase 4** — Catálogo de widgets Flutter usados no projeto
- [x] **Fase 5** — Implementação das interfaces do app (8 telas) + pesquisa e exemplos de StatusBar
- [ ] **Próximos passos** — Salvar progresso no aparelho, blocos *se/senão* e *função*, novas fases e mundos, sons
- [ ] **Futuro** — Testes com usuários de 10–14 anos e publicação gratuita na Play Store

<br/>

## 👥 Equipe

<div align="center">

| Integrante |
|---|
| **Carlos Manoel** |
| **Otávio Rossi** |
| **Vinicius Ozawa** |

</div>

<br/>

## 🏫 Instituição

<div align="center">

![IFSULDEMINAS](https://img.shields.io/badge/Institui%C3%A7%C3%A3o-IFSULDEMINAS-1C1830?style=for-the-badge&labelColor=0C0A14)
![Campus](https://img.shields.io/badge/Campus-Machado-818CF8?style=for-the-badge&labelColor=0C0A14)
![Curso](https://img.shields.io/badge/Curso-T%C3%A9cnico%20em%20Inform%C3%A1tica-34D399?style=for-the-badge&labelColor=0C0A14)
![Ano](https://img.shields.io/badge/Ano-3%C2%BA%20ano-FACC15?style=for-the-badge&labelColor=0C0A14)

</div>

Projeto desenvolvido para a disciplina de **Desenvolvimento de Dispositivos Móveis**, no **Instituto Federal de Educação, Ciência e Tecnologia do Sul de Minas Gerais — Campus Machado**, curso Técnico em Informática (3º ano).

<br/>

<div align="center">

### 🚀 Em desenvolvimento — Fase 5: interfaces do app implementadas! 🚀

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:E11D48,50:818CF8,100:0C0A14&height=120&section=footer"/>

</div>