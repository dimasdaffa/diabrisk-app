import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../widgets/parameter_input_row.dart';
import 'result_screen.dart';

class ParameterScreen extends StatefulWidget {
  const ParameterScreen({Key? key}) : super(key: key);

  @override
  State<ParameterScreen> createState() => _ParameterScreenState();
}

class _ParameterScreenState extends State<ParameterScreen> {
  // Buat 8 Controller untuk 8 parameter
  final List<TextEditingController> _controllers = List.generate(8, (_) => TextEditingController());
  bool _isLoading = false;

  // Fungsi Logika Rekomendasi Berdasarkan Inputan Teks Anda
  List<String> _getRecommendations(int prediction) {
    if (prediction == 1) {
      return [
        "⚠️ Segera Konsultasi: Melakukan pemeriksaan HbA1c ke fasilitas kesehatan terdekat.",
        "1. Manajemen Nutrisi (Diet): Penerapan Pola 3J (Jadwal: 3x makan utama & 2-3x selingan, Jumlah: porsi sesuai kalori, Jenis: karbohidrat kompleks & tinggi serat). Ganti lemak jenuh dengan tak jenuh.",
        "2. Aktivitas Fisik (Olahraga): Lakukan aerobik minimal 150 menit/minggu (30 menit x 5 hari). Sangat disarankan berjalan kaki 15-20 menit setelah makan untuk menekan lonjakan gula darah.",
        "3. Pemantauan & Kepatuhan: Lakukan cek Gula Darah Mandiri secara rutin, terutama jika fisik tidak stabil. Jangan ubah/hentikan dosis obat tanpa anjuran dokter.",
        "4. Perawatan Preventif: Lakukan Foot Care (periksa kaki tiap hari dari luka/lecet karena mati rasa neuropati). Kelola stres dan pastikan tidur berkualitas untuk mencegah kenaikan kortisol.",
        "5. Target Harian: Tetapkan target 5.000 - 7.000 langkah kaki setiap hari sebagai langkah awal pencegahan dan edukasi instan bahaya gula tersembunyi."
      ];
    } else {
      return [
        "✅ Skrining Risiko Rendah. Tetap pertahankan gaya hidup sehat dengan langkah preventif berikut:",
        "1. Aktivitas Fisik: Lakukan olahraga aerobik ringan 30 menit sehari untuk menjaga stabilitas insulin.",
        "2. Manajemen Nutrisi: Kurangi konsumsi gula sederhana (sirup, soda) dan perbanyak asupan sayuran tinggi serat.",
        "3. Manajemen Stres & Tidur: Jaga kualitas tidur, karena stres dapat memicu lonjakan gula darah tersembunyi."
      ];
    }
  }

  // Fungsi menembak API
  Future<void> _sendDataToApi() async {
    setState(() => _isLoading = true);

    // PENTING: Gunakan 10.0.2.2 jika di Emulator Android. 
    // Gunakan IP WiFi Laptop Anda (misal 192.168.1.x) jika menggunakan HP Fisik.
    final url = Uri.parse('http://10.0.2.2:8000/predict'); 

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "pregnancies": double.tryParse(_controllers[0].text) ?? 0.0,
          "glucose": double.tryParse(_controllers[1].text) ?? 0.0,
          "blood_pressure": double.tryParse(_controllers[2].text) ?? 0.0,
          "skin_thickness": double.tryParse(_controllers[3].text) ?? 0.0,
          "insulin": double.tryParse(_controllers[4].text) ?? 0.0,
          "bmi": double.tryParse(_controllers[5].text) ?? 0.0,
          "dpf": double.tryParse(_controllers[6].text) ?? 0.0,
          "age": double.tryParse(_controllers[7].text) ?? 0.0,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        int prediction = result['prediction'];
        
        List<String> recommendations = _getRecommendations(prediction);
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                prediction: prediction,
                recommendations: recommendations,
              ),
            ),
          );
        }
      } else {
        throw Exception("Server mengembalikan status: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghubungi server: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<IconData> _getParameterIcons() {
    return [
      Icons.pregnant_woman,
      Icons.bloodtype,
      Icons.favorite,
      Icons.scale,
      Icons.science,
      Icons.monitor_weight,
      Icons.explore,
      Icons.cake,
    ];
  }

  @override
  void dispose() {
    // Bersihkan memory controller
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icons = _getParameterIcons();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Skrining Kesehatan'),
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.heart_broken, size: 24, color: AppColors.primaryBlue),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.primaryTeal],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Isikan Data Kesehatan Anda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Berikan data lengkap untuk hasil skrining yang akurat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Parameter Cards
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppStrings.parameters.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                icons[index],
                                color: AppColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.parameters[index],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.parameterHints[index],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ParameterInputRow(
                          hintText: AppStrings.parameterHints[index],
                          controller: _controllers[index],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _sendDataToApi,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.search, size: 20),
                  label: Text(
                    _isLoading ? 'Menganalisis...' : 'Mulai Skrining',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }


}
