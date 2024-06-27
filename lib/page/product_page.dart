import 'package:flutter/material.dart';
import 'package:myapp/data/api_service.dart';
import 'package:myapp/model/product.dart';
import 'package:myapp/page/add_product_page.dart';
import 'package:myapp/page/Update_Product_Page.dart';
class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:3000');

  List<Product> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      products = await apiService.getProducts();
    } catch (e) {
      print('Error fetching products: $e');
      // Handle error if needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navigateToAddProductPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(apiService: apiService),
      ),
    );

    if (result == true) {
      fetchProducts();
    }
  }

  Future<void> _navigateToUpdateProductPage(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(apiService: apiService, product: product),
      ),
    );

    if (result == true) {
      fetchProducts();
    }
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await apiService.deleteProduct(productId);
      fetchProducts();
    } catch (e) {
      print('Error deleting product: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreen[400],
      ),
      backgroundColor: Color.fromARGB(255, 220, 243, 189),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text(
                            'Price: \$${product.price.toString()}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Date Added: ${_formatDate(product.dateAdded)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Available: ${product.isAvailable ? 'Yes' : 'No'}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                           Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _navigateToUpdateProductPage(product),
                              child: Text('Edit'),
                            ),
                            SizedBox(width: 8.0),
                            TextButton(
                              onPressed: () => _deleteProduct(product.id),
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen[400],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
