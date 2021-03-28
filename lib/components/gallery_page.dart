import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  final VoidCallback shouldLogOut;
  final VoidCallback shouldShowCamera;

  GalleryPage({Key key, this.shouldLogOut, this.shouldShowCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeria'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child:
                GestureDetector(child: Icon(Icons.logout), onTap: shouldLogOut),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt), onPressed: shouldShowCamera),
      body: Container(child: _galleryGrid()),
    );
  }

  Widget _galleryGrid() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Placeholder();
      },
      itemCount: 3,
    );
  }
}
