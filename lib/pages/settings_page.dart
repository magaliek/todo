import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/app_settings.dart';
import 'package:provider/provider.dart';
import '../widgets/CustomScaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double sliderValue;

  Color _pickerColor = Colors.white;
  Color _currentColor = Colors.white;

  void _changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  void _pickColor(String which) {
    final s = context.read<AppSettings>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: s.backgroundColor,

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: _pickerColor,
                  onColorChanged: _changeColor,

                  colorPickerWidth: 260,
                  pickerAreaHeightPercent: 0.55,
                  pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8)),

                  paletteType: PaletteType.hueWheel,
                  enableAlpha: true,
                  displayThumbColor: true,
                  portraitOnly: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _currentColor = _pickerColor;
                        });
                        switch (which) {
                          case "b":  s.setBackgroundColor(_currentColor); break;
                          case "t":  s.setForegroundColor(_currentColor); break;
                          case "t2": s.setTaskTextColor(_currentColor); break;
                          case "g1": s.setGradientBegin(_currentColor); break;
                          case "g2": s.setGradientEnd(_currentColor); break;
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Select"),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    sliderValue = context.read<AppSettings>().taskTextSize;
  }


  @override
  Widget build(BuildContext context) {
    final fonts = [
      "Orbitron",
      "Lato",
      "Oswald",
      "Merriweather",
      "Roboto",
      "Poppins",
      "Montserrat",
      "Kanit",
      "Quicksand",
      "Inconsolata",
      "Dancing Script",
      "Dosis",
      "EB Garamond",
      "Exo 2",
      "Bitter",
      "Smooch Sans",
      "Space Grotesk",
      "Crimson Text",
      "Michroma",
      "Abel",
      "Overpass",
      "Rajdhani",
      "Zilla Slab",
      "Comfortaa",
      "Lobster Two",
      "Cormorant Garamond",
      "Indie Flower",
      "Cinzel",
      "Chakra Petch",
      "Rubik Mono One",
      "Marcellus",
      "Unbounded",
      "Righteous",
      "Spectral",
      "Amatic SC",
      "Great Vibes",
      "Amiri",
      "News Cycle",
      "Crimson Pro",
      "JetBrains Mono",
      "Gravitas One",
      "Press Start 2P",
      "Sacramento",
    ];

    return CustomScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
        ),
      ),
      body:
      Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Global settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      _pickColor("b");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Set background color"),
                    ),
                  ),
                  Consumer<AppSettings>(
                    builder: (context, settings, child) {
                      return InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                          if (image != null) {
                            settings.setBackgroundImage(image.path);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text("Set background image"),
                        ),
                      );
                    }
                  ),
                  Consumer<AppSettings>(
                    builder: (context, settings, child) {
                      return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      height: 300,
                                      child: Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: fonts.map((font) {
                                            return ListTile(
                                              title: Text(
                                                font,
                                                style: GoogleFonts.getFont(font, fontSize: 14),
                                              ),
                                              onTap: () {
                                                settings.setGlobalFont(font);
                                                Navigator.pop(context);
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text("Set global font"),
                          ),
                      );
                    }
                  ),
                  InkWell(
                    onTap: () {
                      _pickColor("t");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Set global text color"),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height:20),

            Text(
              "Tasks' settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:25.0),
              child: Consumer<AppSettings>(
              builder: (context, settings, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: fonts.map((font) {
                                        return ListTile(
                                          title: Text(
                                            font,
                                            style: GoogleFonts.getFont(
                                                font, fontSize: 14),
                                          ),
                                          onTap: () {
                                            settings.setTaskFont(font);
                                            Navigator.pop(context);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text("Set tasks' font"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setInnerState) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[200],
                                  title: Center(child: Text(
                                    "Slide to size",
                                    style: TextStyle(color: Colors.black),
                                  )),
                                  content: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 50,
                                  ),
                                  child: Row(
                                    children: [
                                      Slider(
                                        value: sliderValue,
                                        min: 8,
                                        max: 34,
                                        divisions: 17,
                                        label: sliderValue.round().toString(),
                                        activeColor: Colors.grey[900],
                                        thumbColor: Colors.black,
                                        onChanged: (value) {
                                          setInnerState(() {
                                          sliderValue = value;
                                        });
                                        }
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            settings.setTaskTextSize(sliderValue);
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.check, color: Colors.black,),
                                      )
                                    ],
                                  ),
                                  ),
                                );
                              }
                            );
                          }
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text("Set tasks' text size"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _pickColor("t2");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text("Set tasks' text color"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _pickColor("g1");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text("Set trash gradient start color"),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        _pickColor("g2");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text("Set trash gradient end color"),
                      ),
                    ),
                  ],
                );
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}