class Planet {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int color;
  final int accentColor;
  final double size;
  final String distance;
  final String moons;
  final String temperature;

  const Planet({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
    required this.accentColor,
    required this.size,
    required this.distance,
    required this.moons,
    required this.temperature,
  });
}
const List<Planet> planets = [
  Planet(
    id: 'mercury',
    name: 'Mercúrio',
    description:
        'O menor e mais rápido planeta do Sistema Solar. Suas temperaturas extremas variam de -180°C à noite a +430°C durante o dia, pois não possui atmosfera para reter o calor.',
    emoji: '🪨',
    color: 0xFFB5A396,
    accentColor: 0xFFD4C5B5,
    size: 0.4,
    distance: '77 mi km',
    moons: '0 luas',
    temperature: '-180°C / +430°C',
  ),
  Planet(
    id: 'venus',
    name: 'Vênus',
    description:
        'O planeta mais quente do Sistema Solar, com temperaturas que chegam a 465°C. Sua atmosfera densa de CO₂ cria um efeito estufa intenso, tornando-o brilhante no céu noturno.',
    emoji: '🌕',
    color: 0xFFE8C97A,
    accentColor: 0xFFF5E0A0,
    size: 0.9,
    distance: '261 mi km',
    moons: '0 luas',
    temperature: '+465°C',
  ),
  Planet(
    id: 'earth',
    name: 'Terra',
    description:
        'Nosso lar! O único planeta conhecido a abrigar vida. Com 71% da superfície coberta por água e uma atmosfera protetora, a Terra é um oásis único no cosmos.',
    emoji: '🌍',
    color: 0xFF4A90D9,
    accentColor: 0xFF6EB5FF,
    size: 1.0,
    distance: '0 km',
    moons: '1 lua',
    temperature: '-88°C / +58°C',
  ),
  Planet(
    id: 'mars',
    name: 'Marte',
    description:
        'O Planeta Vermelho, com suas paisagens de óxido de ferro, possui o maior vulcão do Sistema Solar (Olympus Mons) e é o principal candidato para colonização humana.',
    emoji: '🔴',
    color: 0xFFD05A2A,
    accentColor: 0xFFFF7B4F,
    size: 0.6,
    distance: '225 mi km',
    moons: '2 luas',
    temperature: '-125°C / +20°C',
  ),
  Planet(
    id: 'jupiter',
    name: 'Júpiter',
    description:
        'O maior planeta do Sistema Solar! Sua Grande Mancha Vermelha é uma tempestade que dura há mais de 350 anos. Seu campo gravitacional protege a Terra de asteroides.',
    emoji: '🟤',
    color: 0xFFC88B3A,
    accentColor: 0xFFE8AA60,
    size: 1.5,
    distance: '778 mi km',
    moons: '95 luas',
    temperature: '-145°C',
  ),
  Planet(
    id: 'saturn',
    name: 'Saturno',
    description:
        'Famoso por seus deslumbrantes anéis de gelo e rocha, Saturno é tão leve que flutuaria na água! Tem ventos que chegam a 1.800 km/h em sua atmosfera.',
    emoji: '🪐',
    color: 0xFFD4B896,
    accentColor: 0xFFEDD5B0,
    size: 1.4,
    distance: '1.4 bi km',
    moons: '146 luas',
    temperature: '-178°C',
  ),
];