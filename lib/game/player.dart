import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import '../skins/skin_manager.dart';
import '../utils/constants.dart';
import 'dodge_game.dart';

class Player extends SpriteComponent with HasHitboxes, Collidable, Tappable {
  final DodgeGame _gameRef;
  double _velocityY = 0;
  bool _isDead = false;
  bool _isInvincible = false;
  double _rotationAngle = 0;

  Player(this._gameRef) : super(size: Vector2.all(GameConstants.playerSize), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    position = Vector2(_gameRef.size.x / 2, _gameRef.size.y * 0.75);
    await _loadSkin();
    _setupHitbox();
  }

  Future<void> _loadSkin() async {
    final skinId = SkinManager().activeSkin;
    final path = SkinManager().getPlayerSpritePath(skinId);
    try {
      sprite = await Sprite.load(path);
    } catch (_) {
      sprite = await _generateFallbackSprite();
    }
  }

  Future<Sprite> _generateFallbackSprite() async {
    final paint = _gameRef.getPaintForSkin(SkinManager().activeSkin);
    final canvasSize = size.x.toInt();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), paint);
    canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.35), size.x * 0.12, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(Offset(size.x * 0.7, size.y * 0.35), size.x * 0.12, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.35), size.x * 0.06, Paint()..color = const Color(0xFF000000));
    canvas.drawCircle(Offset(size.x * 0.7, size.y * 0.35), size.x * 0.06, Paint()..color = const Color(0xFF000000));
    final picture = recorder.endRecording();
    final image = await picture.toImage(canvasSize, canvasSize);
    return Sprite(image);
  }

  void _setupHitbox() {
    final hitbox = HitboxRectangle()..size = size * 0.7..anchor = Anchor.center;
    addHitbox(hitbox);
  }

  @override
  void update(double dt) {
    if (_isDead) return;
    _velocityY += GameConstants.playerGravity * dt;
    position.y += _velocityY * dt;
    _rotationAngle = (_velocityY / 600).clamp(-0.5, 0.5);
    angle = _rotationAngle;
    if (position.y > size.y + _gameRef.size.y * 0.9) { die(); }
    if (position.y < size.y / 2) { position.y = size.y / 2; _velocityY = 0; }
  }

  void jump() {
    if (_isDead) return;
    _velocityY = GameConstants.playerJumpVelocity;
    add(SequenceEffect([
      ScaleEffect.to(Vector2(1.2, 0.8), EffectController(duration: 0.05)),
      ScaleEffect.to(Vector2(1.0, 1.0), EffectController(duration: 0.1)),
    ]));
    _gameRef.onPlayerJump();
  }

  void die() {
    if (_isDead || _isInvincible) return;
    _isDead = true;
    _velocityY = 0;
    add(SequenceEffect([
      MoveByEffect(Vector2(0, -50), EffectController(duration: 0.15)),
      RotateEffect.to(pi * 2, EffectController(duration: 0.4)),
    ]));
    _gameRef.onPlayerDeath();
  }

  void setInvincible(bool value) {
    _isInvincible = value;
    if (value) {
      add(RepeatEffect(
        MoveEffect(path: [Vector2(0, -5), Vector2(0, 5)], EffectController(duration: 0.1, infinite: true)),
        infinite: true,
      ));
    }
  }

  bool get isDead => _isDead;
  bool get isInvincible => _isInvincible;

  void reset() {
    _isDead = false; _isInvincible = false; _velocityY = 0; _rotationAngle = 0;
    angle = 0; scale = Vector2.all(1);
    position = Vector2(_gameRef.size.x / 2, _gameRef.size.y * 0.75);
    removeAllEffects();
  }

  @override
  bool onTapDown(TapDownInfo info) { jump(); return true; }
}
