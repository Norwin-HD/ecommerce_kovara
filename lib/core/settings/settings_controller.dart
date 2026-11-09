import 'package:flutter/foundation.dart';

import '../../data/models/general_settings_model.dart';
import '../../data/models/horario_atencion_model.dart';
import '../../data/repository/general_settings_repository.dart';
import '../../data/repository/horario_atencion_repository.dart';

/// Carga y expone la configuración general de la tienda (GENERAL_SETTINGS)
/// junto con los horarios de atención. Se compone con provider en la app.
class SettingsController extends ChangeNotifier {
  SettingsController({this.settingsRepository, this.horarioRepository});

  /// Repos inyectados (tests/mocks). Si son null se crean de forma perezosa
  /// para no requerir Supabase en el constructor (ej: en tests).
  final GeneralSettingsRepository? settingsRepository;
  final HorarioAtencionRepository? horarioRepository;

  GeneralSettingsRepository? _resolvedSettingsRepo;
  HorarioAtencionRepository? _resolvedHorarioRepo;

  GeneralSettings? _settings;
  List<HorarioAtencion> _horarios = const [];
  Object? _error;
  bool _loading = false;

  GeneralSettings? get settings => _settings;
  List<HorarioAtencion> get horarios => _horarios;
  Object? get error => _error;
  bool get isLoading => _loading;
  bool get hasSettings => _settings != null;

  /// Símbolo de moneda configurado en la tienda (ej: "$").
  String get currencySymbol => _settings?.baseCurrencySymbol ?? r'$';

  /// Código de moneda (ej: USD, EUR).
  String get currencyCode => _settings?.baseCurrencyCode ?? '';

  /// Porcentaje de impuesto. Acepta 16 (porcentaje) o 0.16 (fracción).
  double get taxPercent {
    final tax = _settings?.tax ?? 0;
    return tax > 1 ? tax : tax * 100;
  }

  bool get isTemporarilyClosed => _settings?.isTemporarilyClosed ?? false;

  String? get whatsappNumber => _settings?.whatsappNumber;
  String? get supportEmail => _settings?.supportEmail;
  String? get heroBannerUrl => _settings?.heroBannerUrl;
  String? get logoUrl => _settings?.logoUrl;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final settingsRepo = _resolvedSettingsRepo ??=
          settingsRepository ?? GeneralSettingsRepository();
      final horarioRepo = _resolvedHorarioRepo ??=
          horarioRepository ?? HorarioAtencionRepository();
      final results = await Future.wait<dynamic>([
        settingsRepo.getSettings(),
        horarioRepo.getHorarios(),
      ]);
      _settings = results[0] as GeneralSettings;
      final horarios = results[1] as List<HorarioAtencion>;
      horarios.sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
      _horarios = horarios;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
