//import 'package:ecommerce/data/models/category_data.dart';

import 'package:flutter/material.dart';
import 'package:parkapp/utils/app_color.dart';

class CategoriesCard extends StatelessWidget {
  //final CategoryData categoryData;
  const CategoriesCard({super.key,required this.text,required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,size: 40,)
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            text,//categoryData.categoryName ?? "",
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 21,
                color: AppColor.primaryColor,
                letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}
