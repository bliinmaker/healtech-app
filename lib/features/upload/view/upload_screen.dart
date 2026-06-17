import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/upload_cubit.dart';
import '../cubit/upload_state.dart';
import '../data/upload_repository.dart';
import 'widgets/photo_preview.dart';
import 'widgets/result_card.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadCubit(UploadRepository()),
      child: const _UploadView(),
    );
  }
}

class _UploadView extends StatelessWidget {
  const _UploadView();

  static const _buttonStyle = ButtonStyle(
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(vertical: 14),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('HealTech'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<UploadCubit, UploadState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const _Header(),
                const SizedBox(height: 24),
                _buildPhotoArea(state),
                const SizedBox(height: 20),
                _buildActions(context, state),
                const SizedBox(height: 20),
                if (state is UploadSuccess) ResultCard(data: state.data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoArea(UploadState state) {
    return switch (state) {
      UploadInitial() => const _EmptyPhotoPlaceholder(),
      UploadPhotoSelected s => PhotoPreview(file: s.file),
      UploadLoading s => PhotoPreview(file: s.file),
      UploadSuccess s => PhotoPreview(file: s.file),
      UploadError s => PhotoPreview(
          file: s.file,
          overlay: const Icon(Icons.error_outline, color: Colors.red, size: 48),
        ),
    };
  }

  Widget _buildActions(BuildContext context, UploadState state) {
    final cubit = context.read<UploadCubit>();
    final isLoading = state is UploadLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : cubit.pickPhoto,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Галерея'),
                style: _buttonStyle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : cubit.takePhoto,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Камера'),
                style: _buttonStyle,
              ),
            ),
          ],
        ),
        if (state is! UploadInitial && state is! UploadSuccess) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: isLoading ? null : cubit.upload,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.upload_rounded),
            label: Text(isLoading ? 'Загружаю...' : 'Загрузить'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
        if (state is UploadError) ...[
          const SizedBox(height: 8),
          _ErrorBanner(message: state.message, onRetry: cubit.upload),
        ],
        if (state is UploadSuccess) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: cubit.reset,
            icon: const Icon(Icons.refresh),
            label: const Text('Загрузить другой'),
            style: _buttonStyle,
          ),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Загрузка снимка',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Выберите или сфотографируйте медицинский снимок',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class _EmptyPhotoPlaceholder extends StatelessWidget {
  const _EmptyPhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 64, color: Color(0xFFBDBDBD)),
          SizedBox(height: 12),
          Text(
            'Снимок не выбран',
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
