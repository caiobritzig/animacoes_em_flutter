import 'package:flutter/material.dart';
import '../models/planet.dart';

class PlanetCard extends StatefulWidget {
  final Planet planet;
  final VoidCallback? onTap;
  final bool compact;

  const PlanetCard({
    super.key,
    required this.planet,
    this.onTap,
    this.compact = false,
  });

  @override
  State<PlanetCard> createState() => _PlanetCardState();
}

class _PlanetCardState extends State<PlanetCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _glowController.repeat(reverse: true);
    } else {
      _glowController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final planetColor = Color(widget.planet.color);
    final accentColor = Color(widget.planet.accentColor);

    return GestureDetector(
      onTap: widget.onTap ?? _toggleExpand,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            margin: EdgeInsets.symmetric(
              vertical: _isExpanded ? 8 : 4,
              horizontal: widget.compact ? 0 : 16,
            ),
            padding: EdgeInsets.all(widget.compact ? 12 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_isExpanded ? 24 : 16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  planetColor.withValues(alpha: 0.85),
                  planetColor.withValues(alpha: 0.45),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: planetColor.withValues(
                    alpha:
                        _isExpanded ? 0.5 + (_glowAnimation.value * 0.3) : 0.2,
                  ),
                  blurRadius:
                      _isExpanded ? 20 + (_glowAnimation.value * 10) : 8,
                  spreadRadius: _isExpanded ? 2 : 0,
                ),
              ],
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'planet-emoji-${widget.planet.id}',
                  child: Text(
                    widget.planet.emoji,
                    style: TextStyle(
                      fontSize: widget.compact ? 32 : 48 * widget.planet.size,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'planet-name-${widget.planet.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            widget.planet.name,
                            style: TextStyle(
                              fontSize: widget.compact ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.planet.distance,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.compact)
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
            if (!widget.compact) ...[
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.planet.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          StatBadge(
                            label: '🌡 ${widget.planet.temperature}',
                            color: Color(widget.planet.accentColor),
                          ),
                          StatBadge(
                            label: '🌙 ${widget.planet.moons}',
                            color: Color(widget.planet.accentColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatBadge extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const StatBadge({
    super.key,
    required this.label,
    required this.color,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
