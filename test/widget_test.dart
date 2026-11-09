import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_kovara/app/app.dart';
import 'package:ecommerce_kovara/data/models/categoria_model.dart';
import 'package:ecommerce_kovara/data/models/producto_model.dart';
import 'package:ecommerce_kovara/data/repository/categoria_repository.dart';
import 'package:ecommerce_kovara/data/repository/producto_repository.dart';

void main() {
  testWidgets('muestra la navegación del catálogo', (tester) async {
    await tester.pumpWidget(
      KovaraApp(
        productoRepository: _FakeProductoRepository(),
        categoriaRepository: _FakeCategoriaRepository(),
      ),
    );
    await tester.pump();

    expect(find.text('Kovara'), findsWidgets);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Productos'), findsOneWidget);
    expect(find.text('Categorías'), findsOneWidget);
    expect(find.text('Carrito'), findsOneWidget);
  });
}

class _FakeProductoRepository extends ProductoRepository {
  @override
  Future<List<Producto>> getCatalogoPublico() async => [];
}

class _FakeCategoriaRepository extends CategoriaRepository {
  @override
  Future<List<Categoria>> getCategorias() async => [];
}
