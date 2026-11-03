import '../models/general_settings_model.dart';
import '../services/general_settings_service.dart';

class GeneralSettingsRepository {
  final GeneralSettingsService _service;

  GeneralSettingsRepository({GeneralSettingsService? service}) 
      : _service = service ?? GeneralSettingsService();

  Future<GeneralSettings> getSettings() async {
    try {
      final rawData = await _service.obtenerConfiguracionRaw();
      return GeneralSettings.fromJson(rawData);
    } catch (e) {
      rethrow;
    }
  }
}