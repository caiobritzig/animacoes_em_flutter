// screens/planet_detail_screen.dart
// Tela de DESTINO da Hero Animation
// Exibe detalhes completos do planeta com animações

import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../widgets/planet_card.dart';
import '../widgets/orbit_painter.dart';

class PlanetDetailScreen extends StatefulWidget {
  final Planet planet;

  const PlanetDetailScreen({super.key, required this.planet});

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen>
    with TickerProviderStateMixin {
  // ✅ ANIMAÇÃO EXPLÍCITA: rotação do planeta
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  // Animação de entrada dos elementos de detalhe
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Controller de rotação contínua do planeta
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // loop infinito

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController); // sem curve para rotação linear

    // Controller de entrada dos detalhes
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Inicia animação de entrada após o Hero terminar (~300ms)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose(); // SEMPRE chamar dispose!
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planetColor = Color(widget.planet.color);
    final accentColor = Color(widget.planet.accentColor);
    return Scaffold(
      backgroundColor: const Color(0xFF060B1A),
      body: Stack(
        children: [
          // Background: CustomPainter de órbitas animado
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, _) {
              return CustomPaint(
                painter: OrbitPainter(
                  animationValue: _rotationAnimation.value,
                  orbitColor: planetColor,
                  orbitCount: 2,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // Conteúdo principal
          SafeArea(
            child: Column(
              children: [
                // AppBar customizada
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Text(
                        'Sistema Solar',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // balancear o back button
                    ],
                  ),
                ),

                // Seção do planeta com Hero animations
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hero: emoji do planeta (ORIGEM: PlanetCard)
                        Hero(
                          tag: 'planet-emoji-${widget.planet.id}',
                          child: AnimatedBuilder(
                            animation: _rotationAnimation,
                            builder: (context, child) {
                              // Rotação suave usando Transform
                              return Transform.scale(
                                scale: 1.0 +
                                    (0.05 *
                                        (1 +
                                            (2 *
                                                    3.14159 *
                                                    _rotationAnimation.value)
                                                .abs()
                                                .remainder(1.0))),
                                child: child,
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Anel para Saturno (CustomPainter bônus)
                                if (widget.planet.id == 'saturn')
                                  SizedBox(
                                    width: 200,
                                    height: 100,
                                    child: CustomPaint(
                                      painter: RingPainter(color: accentColor),
                                    ),
                                  ),
                                Text(
                                  widget.planet.emoji,
                                  style: TextStyle(
                                    fontSize:
                                        80 * widget.planet.size.clamp(0.7, 1.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Hero: nome do planeta (ORIGEM: PlanetCard)
                        Hero(
                          tag: 'planet-name-${widget.planet.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.planet.name,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Seção de detalhes com animação de entrada
                Expanded(
                  flex: 3,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: planetColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Descrição
                              Text(
                                widget.planet.description,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Estatísticas com StatBadge (widget reutilizável)
                              Text(
                                'Dados do Planeta',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  StatBadge(
                                    label: '📏 ${widget.planet.distance}',
                                    color: accentColor,
                                    fontSize: 13,
                                  ),
                                  StatBadge(
                                    label: '🌙 ${widget.planet.moons}',
                                    color: accentColor,
                                    fontSize: 13,
                                  ),
                                  StatBadge(
                                    label: '🌡 ${widget.planet.temperature}',
                                    color: accentColor,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Botão M3 FilledButton
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.rocket_launch),
                                  label: const Text('Explorar outros planetas'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: planetColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
