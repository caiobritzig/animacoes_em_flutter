#  Galeria Espacial — Animações Flutter

**Atividade Prática — Aula 9 | Desenvolvimento para Dispositivos Móveis**  
Faculdade Senac Joinville | 5ª Fase — 2025/1

---

##  Sobre o Projeto

Um aplicativo Flutter com tema de **Galeria do Sistema Solar**, demonstrando diferentes tipos de animações e boas práticas do Flutter com Material Design 3.

---

##  Requisitos Implementados

### 1. Animação Implícita
- **`AnimatedContainer`** — Cada `PlanetCard` expande/contrai suavemente ao toque, animando `borderRadius`, `padding`, `boxShadow` e gradiente simultaneamente (350ms, `Curves.easeInOutCubic`)
- **`AnimatedOpacity`** — Fade in dos cards ao carregar a lista, com delays escalonados (100ms por item)
- **`AnimatedSlide`** — Slide lateral junto com o fade de entrada dos cards
- **`AnimatedCrossFade`** — Troca suave entre estado colapsado e expandido dentro do card
- **`AnimatedRotation`** — Rotação da seta indicadora ao expandir/colapsar o card

### 2. Animação Explícita
- **`AnimationController` + `Tween<double>` + `CurvedAnimation` + `AnimatedBuilder`** em dois lugares:
  - **Título da galeria**: pulso de escala (1.0→1.05) com `ColorTween` (branco → azul claro), 2000ms, `Curves.easeInOut`, loop reverso
  - **Rotação do planeta** na tela de detalhes: `AnimationController` em loop contínuo com `Tween<double>(0→1)` representando uma volta completa
- **`dispose()`** chamado em todos os controllers

### 3. Hero Animation
- **Tag `'planet-emoji-{id}'`**: transição do emoji do planeta do card para a tela de detalhes
- **Tag `'planet-name-{id}'`**: transição do nome do planeta do card para o título da tela de detalhes
- Cada planeta tem ID único, garantindo tags globalmente únicas

### 4. Material Design 3
- `useMaterial3: true` no `ThemeData`
- `ColorScheme.fromSeed(seedColor: Color(0xFF4A90D9))` com tema escuro
- Componentes M3 utilizados:
  - `NavigationBar` com `NavigationDestination` (tela principal)
  - `FilledButton.icon` (tela de detalhes)

### 5. Widget Customizado Reutilizável
- **`PlanetCard`** — Card completo com animações integradas. Recebe `planet`, `onTap` e `compact` como parâmetros. Usado em `GalleryScreen` (lista) e pode ser reaproveitado em qualquer listagem
- **`StatBadge`** — Chip de estatística reutilizável. Recebe `label`, `color` e `fontSize`. Usado em:
  - `PlanetCard` (seção expandida)
  - `PlanetDetailScreen` (seção de dados do planeta)

---

##  Bônus: CustomPainter

### `OrbitPainter`
- Desenha 3 anéis orbitais com `canvas.drawCircle()`
- Planetas em órbita calculados com `sin/cos`
- Estrela central com 5 pontas usando `canvas.drawPath()`
- Estrelas de fundo com posições pseudo-aleatórias (seed fixo)
- `shouldRepaint()` retorna `true` apenas quando `animationValue` ou `color` mudam

### `RingPainter`
- Desenha anéis de Saturno com `canvas.drawOval()`
- Exibido exclusivamente na tela de detalhes de Saturno

---

##  Estrutura do Projeto

```
lib/
├── main.dart                    # Entrada + ThemeData M3
├── models/
│   └── planet.dart              # Modelo Planet + lista de dados
├── screens/
│   ├── gallery_screen.dart      # Tela principal (origem Hero)
│   └── planet_detail_screen.dart # Tela de detalhes (destino Hero)
└── widgets/
    ├── planet_card.dart         # PlanetCard + StatBadge (reutilizáveis)
    └── orbit_painter.dart       # OrbitPainter + RingPainter (CustomPainter)
```

---

##  Como Executar

```bash
flutter pub get
flutter run
```

Requisitos: Flutter 3.x ou superior, SDK Dart ≥ 3.0.0

---

##  Decisões de Design

- **Tema**: Sistema Solar — permite demonstrar animações de forma natural e contextualizada
- **Paleta**: Fundo escuro `#060B1A` com cores derivadas de cada planeta (tons terrosos, azuis, vermelhos)
- **Duração das animações**: 300–600ms para transições, 2000ms para loops suaves — dentro da faixa recomendada de 200–500ms para feedbacks e até 2000ms para loops contínuos
- **Performance**: `AnimatedBuilder` reconstrói apenas o widget filho afetado; `CustomPainter.shouldRepaint()` evita repaint desnecessário