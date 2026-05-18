import 'dart:async';

import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:flutter/material.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Loader();
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final FutureOr<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return _StateBody(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
  });

  final Object message;
  final String? title;
  final FutureOr<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final text = message.toString();

    return _StateBody(
      icon: _isConnectionMessage(text)
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
      title: title ?? _defaultErrorTitle(text),
      message: text,
      actionLabel: onRetry == null ? null : 'Retry',
      onAction: onRetry,
    );
  }
}

class AppSliverLoadingState extends StatelessWidget {
  const AppSliverLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: AppLoadingState(),
    );
  }
}

class AppSliverEmptyState extends StatelessWidget {
  const AppSliverEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final FutureOr<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AppEmptyState(
        icon: icon,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}

class AppSliverErrorState extends StatelessWidget {
  const AppSliverErrorState({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
  });

  final Object message;
  final String? title;
  final FutureOr<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AppErrorState(message: message, title: title, onRetry: onRetry),
    );
  }
}

class _StateBody extends StatefulWidget {
  const _StateBody({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final FutureOr<void> Function()? onAction;

  @override
  State<_StateBody> createState() => _StateBodyState();
}

class _StateBodyState extends State<_StateBody> {
  bool _busy = false;

  Future<void> _runAction() async {
    final action = widget.onAction;
    if (action == null || _busy) return;

    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 46, color: scheme.onSurfaceVariant),
              const SizedBox(height: 14),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              if (widget.message != null && widget.message!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.message!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (widget.actionLabel != null && widget.onAction != null)
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: FilledButton.icon(
                    onPressed: _busy ? null : _runAction,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh_rounded),
                    label: Text(widget.actionLabel!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isConnectionMessage(String message) {
  final normalized = message.toLowerCase();
  return normalized.contains('offline') ||
      normalized.contains('internet') ||
      normalized.contains('network') ||
      normalized.contains('connection') ||
      normalized.contains('timed out') ||
      normalized.contains('server') ||
      normalized.contains('empty response');
}

String _defaultErrorTitle(String message) {
  return _isConnectionMessage(message)
      ? 'Connection problem'
      : 'Something went wrong';
}
