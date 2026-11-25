import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/location_model.dart';

class LocationTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const LocationTile({
    super.key,
    required this.location,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.light.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withAlpha(12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.location_city_rounded,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.darkest,
          ),
        ),
        subtitle: Text(
          [
            if (location.admin1 != null && location.admin1!.isNotEmpty) location.admin1,
            if (location.country != null && location.country!.isNotEmpty) location.country,
          ].join(', '),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            location.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: location.isFavorite ? Colors.amber : AppColors.light,
            size: 26,
          ),
          onPressed: onToggleFavorite,
          tooltip: location.isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
        ),
        onTap: onTap,
      ),
    );
  }
}
