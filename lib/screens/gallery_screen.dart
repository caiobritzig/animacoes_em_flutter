// screens/gallery_screen.dart
// Tela principal: Galeria de Planetas
// ORIGEM das Hero Animations

import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../widgets/planet_card.dart';
import '../widgets/orbit_painter.dart';
import 'planet_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  // ✅ ANIMAÇÃO EXPLÍCITA: rotação do background de órbitas
  late AnimationController _orbitController;
  late Animation<double> _orbitAnimation;

  // Animação explícita: pulso do título
  late AnimationController _titleController;
  late Animation<double> _titleScale;
  late Animation<Color?> _titleColor;

  // Estado para NavigationBar (Material Design 3)
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Controller das órbitas (rotação contínua do background)
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _orbitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _orbitController, curve: Curves.linear),
    );

    // Controller do título: pulso de escala + cor
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _titleScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    _titleColor = ColorTween(
      begin: Colors.white,
      end: const Color(0xFFB3D4FF),
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbitController.dispose(); // SEMPRE chamar dispose!
    _titleController.dispose();
    super.dispose();
  }

  void _navigateToPlanet(Planet planet) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PlanetDetailScreen(planet: planet),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Transição com fade sutil para complementar o Hero
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060B1A),
      body: Stack(
        children: [
          // Background animado: CustomPainter de órbitas (BÔNUS)
          AnimatedBuilder(
            animation: _orbitAnimation,
            builder: (context, _) {
              return CustomPaint(
                painter: OrbitPainter(
                  animationValue: _orbitAnimation.value,
                  orbitColor: const Color(0xFF4A90D9),
                  orbitCount: 3,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // Conteúdo principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com título animado
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SISTEMA SOLAR',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 4,
                          color: Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // ✅ ANIMAÇÃO EXPLÍCITA com AnimatedBuilder
                      AnimatedBuilder(
                        animation: _titleController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _titleScale.value,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Galeria\nEspacial',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: _titleColor.value,
                                height: 1.1,
                                letterSpacing: -1,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toque para explorar cada planeta',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Lista de planetas com AnimatedOpacity na entrada
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: planets.length,
                    itemBuilder: (context, index) {
                      return _AnimatedListItem(
                        delay: Duration(milliseconds: 100 * index),
                        // ✅ ANIMAÇÃO IMPLÍCITA: dentro de PlanetCard (AnimatedContainer)
                        // ✅ HERO ANIMATION: tag definida dentro de PlanetCard
                        child: PlanetCard(
                          planet: planets[index],
                          onTap: () => _navigateToPlanet(planets[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ✅ MATERIAL DESIGN 3: NavigationBar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0D1425),
        indicatorColor: const Color(0xFF4A90D9).withValues(alpha: 0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.white),
            label: 'Galeria',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: Colors.white54),
            selectedIcon: Icon(Icons.explore, color: Colors.white),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline, color: Colors.white54),
            selectedIcon: Icon(Icons.bookmark, color: Colors.white),
            label: 'Salvos',
          ),
        ],
      ),
    );
  }
}

/// Widget interno para animar a entrada de cada item da lista
/// com AnimatedOpacity (animação implícita)
class _AnimatedListItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _AnimatedListItem({
    required this.child,
    required this.delay,
  });

  @override
  State<_AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ANIMAÇÃO IMPLÍCITA: AnimatedOpacity (fade in dos itens)
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0.1, 0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
