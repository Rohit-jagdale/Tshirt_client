import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String offerTag;

  final Function onTap;
  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.offerTag,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 120,
              ),
              SizedBox(height: 8),
              Text(
                  name,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis
              ),
              SizedBox(height: 8),
              Text(
                  "Rs : $price",
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),// Optional padding
                // Set the background color to green
                child: Text(
                  offerTag,
                  style: TextStyle(
                    color: Colors.white, // Text color set to white
                    fontSize: 12, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}
