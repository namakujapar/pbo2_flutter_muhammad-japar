import 'package:flutter/material.dart';
import 'agenda.dart';
import 'agenda_service.dart';

class AgendaForm extends StatefulWidget {
  final Agenda? agenda;
  const AgendaForm({super.key, this.agenda});

  @override
  State<AgendaForm> createState() => _AgendaFormState();
}

class _AgendaFormState extends State<AgendaForm> {
  final _formKey = GlobalKey<FormState>();
  final _judul = TextEditingController();
  final _ket = TextEditingController();
  final _service = AgendaService();

  @override
  void initState() {
    super.initState();
    if (widget.agenda != null) {
      _judul.text = widget.agenda!.judul;
      _ket.text = widget.agenda!.keterangan;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final agenda = Agenda(
        id: widget.agenda?.id,
        judul: _judul.text,
        keterangan: _ket.text,
      );
      try {
        if (widget.agenda == null) {
          await _service.create(agenda);
        } else {
          await _service.update(agenda.id!, agenda);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Gagal simpan: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR GRADIENT
      appBar: AppBar(
        title: Text(
          widget.agenda == null ? 'Tambah Agenda' : 'Edit Agenda',
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // BODY
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFECE9E6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadowColor: Colors.blueAccent.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // INPUT JUDUL
                    TextFormField(
                      controller: _judul,
                      decoration: InputDecoration(
                        labelText: 'Judul',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.title, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wajib isi judul' : null,
                    ),

                    const SizedBox(height: 16),

                    // INPUT KETERANGAN
                    TextFormField(
                      controller: _ket,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Keterangan',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            const Icon(Icons.description, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TOMBOL SIMPAN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
