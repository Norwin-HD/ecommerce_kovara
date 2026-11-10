import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/consts/app_strings.dart';
import '../core/settings/settings_controller.dart';
import '../core/theme/app_theme.dart';
import '../data/repository/categoria_repository.dart';
import '../data/repository/general_settings_repository.dart';
import '../data/repository/horario_atencion_repository.dart';
import '../data/repository/marca_repository.dart';
import '../data/repository/producto_repository.dart';
import '../features/cart/cart_controller.dart';
import 'router.dart';

/// Raíz de la aplicación: providers, tema y rutas.
class KovaraApp extends StatelessWidget {
  const KovaraApp({
    super.key,
    this.productoRepository,
    this.categoriaRepository,
    this.marcaRepository,
    this.settingsRepository,
    this.horarioRepository,
  });

  /// Permite inyectar repositorios (tests / mocks).
  final ProductoRepository? productoRepository;
  final CategoriaRepository? categoriaRepository;
  final MarcaRepository? marcaRepository;
  final GeneralSettingsRepository? settingsRepository;
  final HorarioAtencionRepository? horarioRepository;

  @override
  Widget build(BuildContext context) {
    final productoRepo = productoRepository ?? ProductoRepository();
    final categoriaRepo = categoriaRepository ?? CategoriaRepository();
    final marcaRepo = marcaRepository ?? MarcaRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>(
          create: (_) => SettingsController(
            settingsRepository: settingsRepository,
            horarioRepository: horarioRepository,
          )..load(),
        ),
        ChangeNotifierProvider<CartController>(
          create: (_) => CartController(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        onGenerateRoute: AppRouter(
          productoRepository: productoRepo,
          categoriaRepository: categoriaRepo,
          marcaRepository: marcaRepo,
        ).onGenerateRoute,
      ),
    );
  }
}
