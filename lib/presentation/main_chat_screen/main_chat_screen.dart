import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/audio_waveform_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/persona_avatar_widget.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  int _selectedPersonaIndex = 0;
  bool _isTyping = false;
  bool _isPlayingAudio = false;
  String _currentPlayingMessageId = '';
  final List<Map<String, dynamic>> _messages = [];

  late AnimationController _glowAnimationController;
  late Animation<double> _glowAnimation;

  final List<Map<String, dynamic>> _personas = [
    {
      "id": "socrates",
      "name": "Socrates",
      "avatar":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop&crop=face",
      "description": "The questioning philosopher",
      "color": AppTheme.activeCyan,
    },
    {
      "id": "diogenes",
      "name": "Diogenes",
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=400&h=400&fit=crop&crop=face",
      "description": "The cynic sage",
      "color": AppTheme.warmGold,
    },
    {
      "id": "nicolas",
      "name": "Nicolas-the-Smoker",
      "avatar":
          "https://images.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg?w=400&h=400&fit=crop&crop=face",
      "description": "The contemplative thinker",
      "color": AppTheme.historicalSepia,
    },
    {
      "id": "confucius",
      "name": "Cyber-Confucius",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "description": "The digital wisdom keeper",
      "color": AppTheme.brandIndigo,
    },
    {
      "id": "marx",
      "name": "Sarcastic Marx",
      "avatar":
          "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?w=400&h=400&fit=crop&crop=face",
      "description": "The witty revolutionary",
      "color": AppTheme.successGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowAnimationController,
      curve: Curves.easeInOut,
    ));
    _glowAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowAnimationController.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _selectPersona(int index) {
    setState(() {
      _selectedPersonaIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final String messageText = _messageController.text.trim();
    final String messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _messages.add({
        "id": messageId,
        "text": messageText,
        "isUser": true,
        "timestamp": DateTime.now(),
        "personaId": null,
        "hasAudio": false,
      });
      _isTyping = true;
    });

    _messageController.clear();
    HapticFeedback.mediumImpact();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final String responseId =
            'msg_${DateTime.now().millisecondsSinceEpoch}';
        final String selectedPersonaId = _personas[_selectedPersonaIndex]['id'];

        setState(() {
          _messages.add({
            "id": responseId,
            "text": _generatePersonaResponse(messageText, selectedPersonaId),
            "isUser": false,
            "timestamp": DateTime.now(),
            "personaId": selectedPersonaId,
            "hasAudio": true,
          });
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _generatePersonaResponse(String userMessage, String personaId) {
    final Map<String, List<String>> responses = {
      "socrates": [
        "Interesting perspective. But tell me, what assumptions are you making here?",
        "Before we proceed, let us examine what we truly know about this matter.",
        "Your question reveals wisdom in its asking. What do you think the answer might teach us?",
      ],
      "diogenes": [
        "Bah! Society's conventions blind you to simple truths. Look beyond the noise.",
        "Why complicate what nature has made simple? Strip away the pretense.",
        "The answer lies not in books, but in honest living. What would a dog do?",
      ],
      "nicolas": [
        "Hmm... *takes a thoughtful drag* Life's complexities require patient contemplation.",
        "In the smoke of uncertainty, patterns emerge. Consider the deeper currents.",
        "Time reveals all truths, my friend. What does your intuition whisper?",
      ],
      "confucius": [
        "In the digital age, ancient wisdom finds new expression. Balance is key.",
        "The superior person adapts principles to circumstances. How might this apply?",
        "Technology amplifies both wisdom and folly. Choose your path mindfully.",
      ],
      "marx": [
        "Oh, how delightfully bourgeois of you to ask! But seriously, follow the money.",
        "The ruling class would have you believe otherwise, but let's examine the material conditions.",
        "Your question assumes the system works as intended. Spoiler alert: it doesn't.",
      ],
    };

    final List<String> personaResponses =
        responses[personaId] ?? responses["socrates"]!;
    return personaResponses[
        DateTime.now().millisecond % personaResponses.length];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _playAudio(String messageId) {
    setState(() {
      _isPlayingAudio = true;
      _currentPlayingMessageId = messageId;
    });

    HapticFeedback.selectionClick();

    // Simulate audio playback
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
          _currentPlayingMessageId = '';
        });
      }
    });
  }

  void _onMessageLongPress(String messageId, String text) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.softGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.activeCyan,
                size: 24,
              ),
              title: Text(
                'Copy Message',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.warmGold,
                size: 24,
              ),
              title: Text(
                'Share Message',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Share functionality would be implemented here
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshConversation() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh logic would be implemented here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryNavy, // Cleaner background
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // More transparent for cleaner look
        elevation: 0,
        title: Text(
          'ZeitWise Chat',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile-screen'),
            icon: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.activeCyan,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
                  width: 8.w,
                  height: 8.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: Column(
        children: [
          // Persona Avatar Picker
          Container(
            height: 20.h,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryNavy,
                  AppTheme.primaryNavy.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _personas.length,
              itemBuilder: (context, index) {
                return PersonaAvatarWidget(
                  persona: _personas[index],
                  isSelected: index == _selectedPersonaIndex,
                  onTap: () => _selectPersona(index),
                  glowAnimation: _glowAnimation,
                );
              },
            ),
          ),

          // Chat Messages - Cleaner background with more spacing
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryNavy.withValues(alpha: 0.9),
                    AppTheme.deepCharcoal,
                  ],
                ),
              ),
              child: RefreshIndicator(
                onRefresh: _refreshConversation,
                color: AppTheme.activeCyan,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.w, vertical: 3.h), // More spacing
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 2.h), // More spacing between elements
                        child: ChatMessageWidget(
                          message: {
                            "id": "typing",
                            "text": "...",
                            "isUser": false,
                            "timestamp": DateTime.now(),
                            "personaId": _personas[_selectedPersonaIndex]['id'],
                            "hasAudio": false,
                          },
                          persona: _personas[_selectedPersonaIndex],
                          isTyping: true,
                          onAudioPlay: _playAudio,
                          onLongPress: _onMessageLongPress,
                          isPlayingAudio: false,
                        ),
                      );
                    }

                    final message = _messages[index];
                    final persona = message['personaId'] != null
                        ? _personas
                            .firstWhere((p) => p['id'] == message['personaId'])
                        : null;

                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: 2.h), // More spacing between elements
                      child: ChatMessageWidget(
                        message: message,
                        persona: persona,
                        isTyping: false,
                        onAudioPlay: _playAudio,
                        onLongPress: _onMessageLongPress,
                        isPlayingAudio: _isPlayingAudio &&
                            _currentPlayingMessageId == message['id'],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Audio Waveform (when playing)
          if (_isPlayingAudio)
            AudioWaveformWidget(
              isPlaying: _isPlayingAudio,
              onStop: () {
                setState(() {
                  _isPlayingAudio = false;
                  _currentPlayingMessageId = '';
                });
              },
            ),

          // Chat Input
          ChatInputWidget(
            controller: _messageController,
            focusNode: _messageFocusNode,
            onSend: _sendMessage,
            onEmojiTap: () {
              // Emoji picker would be implemented here
              HapticFeedback.lightImpact();
            },
            onMicTap: () {
              // Voice input would be implemented here
              HapticFeedback.mediumImpact();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.bottomNavigationBarTheme.backgroundColor
              ?.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.activeCyan,
          unselectedItemColor: AppTheme.softGray,
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.activeCyan,
                size: 22, // Minimal icon size
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'healing',
                color: AppTheme.softGray,
                size: 22, // Minimal icon size
              ),
              label: 'Detox',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/detox-feed-screen');
            }
          },
        ),
      ),
    );
  }
}