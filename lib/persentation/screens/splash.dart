import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _initialized ? const SplashScreen() : 
      Scaffold(backgroundColor: const Color(0xFF4285F4));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _appearController;
  late Animation<double> _initialSizeAnimation;
  late Animation<double> _positionAnimation;
  late AnimationController _growthController;
  late Animation<double> _growthAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _showLogo = false;
  bool _isNavigating = false;
  bool _startGrowth = false;
  bool _startPulse = false;

  @override
  void initState() {
    super.initState();
    
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _initialSizeAnimation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: Curves.easeOut,
      ),
    );

    _positionAnimation = Tween<double>(begin: 0.15, end: 0.5).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _growthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _growthAnimation = Tween<double>(begin: 30, end: 250).animate(
      CurvedAnimation(
        parent: _growthController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _colorAnimation = ColorTween(
      begin: const Color(0xFF4285F4),
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _growthController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _appearController.forward();
      }
    });

    _appearController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _startGrowth = true;
        });
        _growthController.forward();
      }
    });

    _growthController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _startPulse = true;
        });
        _pulseController.repeat();

        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showLogo = true;
            });

            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted && !_isNavigating) {
                setState(() {
                  _isNavigating = true;
                });
                _pulseController.stop();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _appearController.dispose();
    _growthController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_appearController, _growthController, _pulseController]),
      builder: (context, child) {
        double circleSize = _initialSizeAnimation.value;
        if (_startGrowth) {
          circleSize = _growthAnimation.value;
        }
        
        double pulseScale = _startPulse ? _pulseAnimation.value : 1.0;
        
        return Scaffold(
          backgroundColor: _startGrowth ? _colorAnimation.value : const Color(0xFF4285F4),
          body: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment(0, -1 + _positionAnimation.value * 2),
                  child: Transform.scale(
                    scale: pulseScale,
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              if (_showLogo)
                AnimatedOpacity(
                  opacity: _showLogo ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 45,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// Helper functions
double sqrt(double x) => math.sqrt(x);
double exp(double x) => math.exp(x);
double sin(double x) => math.sin(x);
double cos(double x) => math.cos(x);
