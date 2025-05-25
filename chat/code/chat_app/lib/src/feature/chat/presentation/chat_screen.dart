import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/domain/user.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isComposing = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const ChatLoadMessages());
    _initializeAnimations();

    _messageController.addListener(() {
      setState(() {
        _isComposing = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text.trim();
      _messageController.clear();
      setState(() {
        _isComposing = false;
      });

      // Add haptic feedback
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });

      context.read<ChatBloc>().add(ChatSendMessage(message, widget.user.id));

      // Auto-scroll to bottom after sending
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context, colorScheme),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _buildMessagesList(context, colorScheme, isDesktop),
            ),
            _buildMessageInput(context, colorScheme, isDesktop),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.person,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat Room',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.logout_rounded,
              size: 18,
              color: colorScheme.onErrorContainer,
            ),
          ),
          onPressed: () {
            _showLogoutDialog(context);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMessagesList(
      BuildContext context, ColorScheme colorScheme, bool isDesktop) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: colorScheme.primary,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading messages...',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ChatLoaded) {
          if (state.messages.isEmpty) {
            return _buildEmptyState(context, colorScheme);
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.all(isDesktop ? 24 : 16),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final isMe = message.senderId == widget.user.id;
                final isLastMessage = index == 0;
                final nextMessage = index < state.messages.length - 1
                    ? state.messages[index + 1]
                    : null;
                final showAvatar = nextMessage?.senderId != message.senderId;

                return _buildMessageBubble(
                  context,
                  message,
                  isMe,
                  colorScheme,
                  showAvatar,
                  isLastMessage,
                );
              },
            ),
          );
        } else if (state is ChatError) {
          return _buildErrorState(context, state.message, colorScheme);
        }

        return _buildEmptyState(context, colorScheme);
      },
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    dynamic message, // Replace with your Message type
    bool isMe,
    ColorScheme colorScheme,
    bool showAvatar,
    bool isLastMessage,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: showAvatar ? 16 : 4,
        top: isLastMessage ? 8 : 0,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondary,
                    colorScheme.secondary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: colorScheme.onSecondary,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ] else if (!isMe) ...[
            const SizedBox(width: 40),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: isMe
                          ? LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.8),
                              ],
                            )
                          : null,
                      color: isMe ? null : colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomLeft: isMe
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                        bottomRight: isMe
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isMe ? colorScheme.primary : colorScheme.shadow)
                                  .withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMe
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (showAvatar) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _formatTimestamp(message.timestamp),
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isMe && showAvatar) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: colorScheme.onPrimary,
                size: 16,
              ),
            ),
          ] else if (isMe) ...[
            const SizedBox(width: 40),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(
      BuildContext context, ColorScheme colorScheme, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isComposing
                      ? colorScheme.primary.withValues(alpha: 0.5)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.chat_bubble_outline,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 20,
                  ),
                ),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: _isComposing
                    ? LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.8),
                        ],
                      )
                    : null,
                color: _isComposing ? null : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
                boxShadow: _isComposing
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: IconButton(
                onPressed: _isComposing ? _sendMessage : null,
                icon: Icon(
                  Icons.send_rounded,
                  color: _isComposing
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation by sending your first message!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, String message, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ChatBloc>().add(const ChatLoadMessages());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
