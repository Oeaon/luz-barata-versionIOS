/// Datos propios de esta app: nombre, web, textos legales y fuentes oficiales.
class AppInfo {
  AppInfo._();

  static const name = 'Luz Barata';
  static const privacyUrl = 'https://oeaon.github.io/luz-barata/privacy.html';
  static const termsUrl = 'https://oeaon.github.io/luz-barata/terms.html';

  /// Fuentes oficiales que se enlazan en Ajustes (lo exigen las tiendas para información de organismos públicos).
  static const officialSources = [
    'https://www.esios.ree.es/es/pvpc',
    'https://www.ree.es/es/datos/apidatos',
  ];
}
