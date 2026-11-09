/// Textos visibles de la app. Modifica aquí para cambiar textos sin tocar UI.
class AppStrings {
  AppStrings._();

  static const appName = 'Kovara';
  static const appTagline = 'Laptops y tecnología';

  // Navegación.
  static const tabHome = 'Inicio';
  static const tabProducts = 'Productos';
  static const tabCategories = 'Categorías';
  static const tabCart = 'Carrito';

  // Catálogo.
  static const catalogTitle = 'Catálogo Kovara';
  static const searchHint = 'Buscar laptop, SKU o categoría...';
  static const allCategories = 'Todos';
  static const refresh = 'Actualizar';
  static const seeDetails = 'Ver detalles';
  static const fromPrice = 'Desde';
  static const noPrice = 'Sin precio';

  // Estados.
  static const loading = 'Cargando...';
  static const errorTitle = 'No se pudieron cargar los datos.';
  static const retry = 'Reintentar';
  static const emptyProducts = 'No hay productos disponibles por ahora.';
  static const emptyProductsHint = 'Vuelve a intentarlo más tarde o actualiza la lista.';
  static const emptyCategories = 'No hay categorías registradas.';
  static const emptySearch = 'No encontramos resultados para tu búsqueda.';
  static const emptySearchHint = 'Prueba con otro nombre, SKU o categoría.';

  // Detalle de producto.
  static const descriptionSection = 'Descripción';
  static const noDescription = 'Este producto no tiene descripción.';
  static const variantsSection = 'Variantes';
  static const noVariants = 'No hay variantes disponibles.';
  static const skuLabel = 'SKU';

  // Categorías.
  static const categoriesTitle = 'Categorías';
  static const noCategoryDescription = 'Sin descripción';

  // Inicio / destacados.
  static const featuredSection = 'Destacados';
  static const featuredHint = 'Los productos más recientes de la tienda';
  static const seeAll = 'Ver todo';
  static const temporarilyClosed = 'La tienda está temporalmente cerrada';

  // Inicio - beneficios.
  static const benefitShippingTitle = 'Envío a domicilio';
  static const benefitShippingDesc = 'Coordinamos tu entrega.';
  static const benefitGuaranteeTitle = 'Garantía';
  static const benefitGuaranteeDesc = 'Productos con respaldo.';
  static const benefitSupportTitle = 'Soporte al cliente';
  static const benefitSupportDesc = 'Te atendemos por WhatsApp.';
  static const benefitPaymentTitle = 'Pago seguro';
  static const benefitPaymentDesc = 'Acordamos el pago contigo.';

  // Inicio - categorías rápidas.
  static const quickCategoriesTitle = 'Categorías';

  // Inicio - cómo comprar.
  static const howToBuySection = 'Cómo comprar';
  static const step1Title = 'Elige tu producto';
  static const step1Desc = 'Agréjalo al carrito desde el catálogo.';
  static const step2Title = 'Envía tu pedido';
  static const step2Desc = 'Te abrimos WhatsApp con el pedido armado.';
  static const step3Title = 'Coordina la entrega';
  static const step3Desc = 'Acordamos pago y envío directo contigo.';

  // Información de la tienda (footer).
  static const storeInfoSection = 'Información de la tienda';
  static const openingHours = 'Horario de atención';
  static const writeOnWhatsApp = 'Escribir por WhatsApp';
  static const whatsappLabel = 'WhatsApp';
  static const copyright = 'Todos los derechos reservados.';

  // Carrito.
  static const cartEmpty = 'Tu carrito está vacío';
  static const cartEmptyHint = 'Agrega productos desde el catálogo para pedir por WhatsApp.';
  static const addToCart = 'Agregar al carrito';
  static const addedToCart = 'Agregado al carrito';
  static const cartSummary = 'Resumen del pedido';
  static const subtotalLabel = 'Subtotal';
  static const taxLabel = 'IVA';
  static const totalLabel = 'Total';
  static const clearCart = 'Vaciar carrito';
  static const clearCartConfirm = 'Se quitarán todos los productos del carrito.';
  static const sendOrderWhatsApp = 'Enviar pedido por WhatsApp';
  static const whatsappMissingNumber = 'No hay un número de WhatsApp configurado.';
  static const whatsappOpened = 'Se abrió WhatsApp con tu pedido.';
  static const cancel = 'Cancelar';
  static const quantityLabel = 'Cant.';
  static const removeItem = 'Quitar del carrito';
  static const incrementQuantity = 'Aumentar cantidad';
  static const decrementQuantity = 'Disminuir cantidad';

  static String itemsCount(int count) =>
      '$count ${count == 1 ? 'artículo' : 'artículos'}';
}
