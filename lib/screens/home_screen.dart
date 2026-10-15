import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/clock_dial.dart';
import '../widgets/limbus_button.dart';
import 'quiz_screen.dart';

/// Layar awal: judul di dalam jam, kolom nama, tombol mulai / lanjutkan.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Isi ulang nama jika pemain pernah memulai kuis sebelumnya.
    _nameController =
        TextEditingController(text: context.read<QuizProvider>().playerName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _openQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  void _start() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<QuizProvider>().startQuiz(_nameController.text);
    _openQuiz();
  }

  void _resume() {
    FocusScope.of(context).unfocus();
    _openQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final canResume = context.select<QuizProvider, bool>((q) => q.canResume);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Semua jarak dan ukuran dihitung dari ukuran layar yang tersedia.
            final pad = constraints.maxWidth * 0.06;
            final dialSize = math.min(
              constraints.maxWidth * 0.8,
              constraints.maxHeight * 0.45,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.all(pad),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - pad * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClockDial(
                      size: dialSize,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Limbus', style: text.displayLarge),
                          Text('Company', style: text.headlineMedium),
                          Text('Kuis pilihan ganda', style: text.bodyMedium),
                        ],
                      ),
                    ),
                    SizedBox(height: pad),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            maxLength: 20,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              hintText: 'Masukkan namamu',
                              counterText: '',
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? 'Nama tidak boleh kosong'
                                    : null,
                            onFieldSubmitted: (_) => _start(),
                          ),
                          SizedBox(height: pad * 0.6),
                          LimbusButton(label: 'Mulai kuis', onPressed: _start),
                          if (canResume) ...[
                            SizedBox(height: pad * 0.5),
                            LimbusButton(
                              label: 'Lanjutkan kuis',
                              secondary: true,
                              onPressed: _resume,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: pad),
                    Text(
                      'Aplikasi fan-made, tidak berafiliasi dengan Project Moon.',
                      textAlign: TextAlign.center,
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}