import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/common/widgets/custom_input_field.dart';
import 'package:holdwise/features/explore_screen/data/upload_cubit/advice_upload_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:video_player/video_player.dart';

class AddSpecialistAdviceScreen extends StatefulWidget {
  const AddSpecialistAdviceScreen({Key? key}) : super(key: key);

  @override
  _AddSpecialistAdviceScreenState createState() =>
      _AddSpecialistAdviceScreenState();
}

class _AddSpecialistAdviceScreenState extends State<AddSpecialistAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedMediaType = 'Text';
  File? _mediaFile;
  final ImagePicker _picker = ImagePicker();

  VideoPlayerController? _videoController;

  /// Picks media from the gallery based on the selected media type.
  Future<void> _pickMedia() async {
    if (_selectedMediaType == 'Image') {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _mediaFile = File(pickedImage.path);
        });
      }
    } else if (_selectedMediaType == 'Video') {
      final XFile? pickedVideo =
          await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        // Dispose any previous controller.
        if (_videoController != null) {
          await _videoController!.dispose();
        }
        _mediaFile = File(pickedVideo.path);
        _videoController = VideoPlayerController.file(_mediaFile!)
          ..initialize().then((_) {
            setState(() {}); // Rebuild to reflect video initialization.
          });
      }
    }
  }

  /// Displays a modal dialog with the selected media.
  void _showMediaModal() {
    if (_mediaFile == null) return;

    showDialog(
      context: context,
      builder: (context) {
        if (_selectedMediaType == 'Image') {
          // For image, show a dialog with an InteractiveViewer.
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: GestureDetector(
              // Tap to close the modal.
              onTap: () => Navigator.of(context).pop(),
              child: InteractiveViewer(
                child: Image.file(_mediaFile!),
              ),
            ),
          );
        } else if (_selectedMediaType == 'Video') {
          // For video, show the video player with play/pause controls.
          return Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: _videoController != null &&
                      _videoController!.value.isInitialized
                  ? StatefulBuilder(
                      builder: (context, setModalState) {
                        return Container(
                          color: Colors.black,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                              // Play/pause button overlay.
                              IconButton(
                                icon: Icon(
                                  _videoController!.value.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                  // Update the dialog UI.
                                  setModalState(() {});
                                },
                              ),
                              // Video progress indicator.
                              Positioned(
                                bottom: 20,
                                left: 16,
                                right: 16,
                                child: VideoProgressIndicator(
                                  _videoController!,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: AppColors.primary600,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ));
        }
        return const SizedBox.shrink();
      },
    ).then((_) {
      // Pause the video when the modal is closed.
      if (_selectedMediaType == 'Video' &&
          _videoController != null &&
          _videoController!.value.isPlaying) {
        _videoController!.pause();
      }
    });
  }

  /// Builds a preview widget for the selected media.
  Widget _buildMediaPreview() {
    if (_mediaFile == null) {
      return const Text('No media selected.');
    } else {
      if (_selectedMediaType == 'Image') {
        return Image.file(_mediaFile!, height: 200, fit: BoxFit.cover);
      } else if (_selectedMediaType == 'Video') {
        if (_videoController != null && _videoController!.value.isInitialized) {
          return AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          );
        } else {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      }
    }
    return const SizedBox.shrink();
  }

  /// Triggers the form submission using the AdviceUploadCubit.
  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;

    context.read<AdviceUploadCubit>().uploadAdvice(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          author: user?.displayName ?? 'Unknown',
          authorId: user?.uid ?? 'Unknown',
          category: 'General',
          mediaType: _selectedMediaType,
          mediaFile: _mediaFile,
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeCubit>().state == ThemeMode.dark;

    return BlocListener<AdviceUploadCubit, AdviceUploadState>(
      listener: (context, state) {
        if (state.status == AdviceUploadStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Advice uploaded successfully!')),
          );
          Navigator.of(context).pop();
        } else if (state.status == AdviceUploadStatus.error) {
          log('Error: ${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            // SnackBar(content: Text('Error: ${state.errorMessage}')),
            SnackBar(content: Text('Something went wrong. Please try again.')),
          );
        }
      },
      child: Scaffold(
        appBar: RoleBasedAppBar(title: 'Add Specialist Advice'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title input field.
                CustomTextField(
                  controller: _titleController,
                  hintText: 'Title',
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Content input field.
                CustomTextField(
                  controller: _contentController,
                  hintText: 'Content',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Content is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Media type dropdown selector.
                DropdownButtonFormField<String>(
                  value: _selectedMediaType,
                  decoration: const InputDecoration(
                    labelText: 'Media Type',
                    border: OutlineInputBorder(),
                    iconColor: AppColors.primary600,
                    labelStyle: TextStyle(color: AppColors.primary600),
                  ),
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.primary600),
                  items: [
                    DropdownMenuItem(
                      value: 'Text',
                      child: Text('Text',
                          style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.primary200
                                  : AppColors.primary600)),
                    ),
                    DropdownMenuItem(
                      value: 'Image',
                      child: Text('Image',
                          style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.primary200
                                  : AppColors.primary600)),
                    ),
                    DropdownMenuItem(
                      value: 'Video',
                      child: Text('Video',
                          style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.primary200
                                  : AppColors.primary600)),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMediaType = newValue;
                        _mediaFile =
                            null; // Reset any previously selected media.
                        if (_videoController != null) {
                          _videoController!.dispose();
                          _videoController = null;
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Media picker button and preview (only for Image/Video).
                if (_selectedMediaType != 'Text') ...[
                  ElevatedButton.icon(
                    onPressed: _pickMedia,
                    icon: const Icon(Icons.attach_file),
                    label: Text('Select $_selectedMediaType'),
                  ),
                  const SizedBox(height: 8),
                  // Wrap the media preview in a GestureDetector to open a modal when tapped.
                  GestureDetector(
                    onTap: _showMediaModal,
                    child: _buildMediaPreview(),
                  ),
                  const SizedBox(height: 16),
                ],
                // Submit button.
                BlocBuilder<AdviceUploadCubit, AdviceUploadState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status == AdviceUploadStatus.loading
                          ? null
                          : _submitForm,
                      child: state.status == AdviceUploadStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary600,
                              ),
                            )
                          : const Text('Upload Advice'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
