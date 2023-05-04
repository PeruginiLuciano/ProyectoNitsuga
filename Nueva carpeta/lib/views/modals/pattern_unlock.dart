import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';
import 'package:motorhome/views/modals/dialogs.dart';
import 'package:motorhome/views/widgets/buttons/modal_button.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternUnlock extends StatefulWidget {
  final bool isChangingPattern;

  const PatternUnlock({Key? key, this.isChangingPattern = false}) : super(key: key);

  @override
  State<PatternUnlock> createState() => _PatternUnlockState();
}

class _PatternUnlockState extends State<PatternUnlock> {
  String title = '';
  String subtitle = '';
  bool _unlocked = false;
  List _pattern = [];
  List _previousPattern = [];
  late SharedPreferences prefs;
  bool _isChangingPattern = false;
  bool _cancelButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      final String? savedPattern = prefs.getString('pattern');
      _isChangingPattern = widget.isChangingPattern;
      // await prefs.remove('pattern');

      setState(() {
        if (savedPattern == null) {
          title = 'INGRESAR NUEVO PATRÓN';
          _isChangingPattern = true;
          _cancelButtonEnabled = true;
        } else if (_isChangingPattern) {
          title = 'CAMBIAR PATRÓN DE DESBLOQUEO';
          subtitle = 'INGRESAR PATRÓN ANTERIOR';
          _previousPattern = jsonDecode(savedPattern);
          _cancelButtonEnabled = true;
        } else {
          title = 'INGRESAR PATRÓN DE DESBLOQUEO';
          _previousPattern = jsonDecode(savedPattern);
        }
      });
    });
  }

  void onInputComplete(List<int> input) {
    final String? savedPattern = prefs.getString('pattern');
    bool isMasterPattern = listEquals(masterPattern, input);
    setState(() {
      // Change code
      if (_isChangingPattern) {
        if (_previousPattern.isEmpty) {
          if (_pattern.isEmpty) {
            title = 'CAMBIAR PATRÓN DE DESBLOQUEO';
            if (isMasterPattern) {
              subtitle = 'EL PATRÓN INGRESADO NO ES VÁLIDO, INTENTE NUEVAMENTE';
            } else {
              _pattern = input;
              subtitle = 'REINGRESE SU NUEVO PATRÓN DE DESBLOQUEO';
            }
          } else if (listEquals(_pattern, input)) {
            _unlocked = true;
            subtitle = 'PATRÓN CONFIRMADO';
          } else {
            subtitle = 'PATRÓN NO CONFIRMADO, INTENTE NUEVAMENTE';
          }
        } else if (isMasterPattern || listEquals(_previousPattern, input)) {
          title = 'INGRESAR NUEVO PATRÓN';
          subtitle = "";
          _previousPattern = [];
        } else {
          subtitle = 'PATRÓN ANTERIOR INCORRECTO, INTENTE NUEVAMENTE';
        }
      }
      // Unlock
      else if (savedPattern != null) {
        _pattern = jsonDecode(savedPattern);
        if (isMasterPattern || listEquals(_pattern, input) == true) {
          _unlocked = true;
          subtitle = 'PATRÓN CORRECTO';
        } else {
          title = 'PATRÓN INCORRECTO, INTENTE NUEVAMENTE';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title, style: MHTextStyles.h1Bold.copyWith(color: MHColors.blueDark, fontSize: 30), textAlign: TextAlign.center),
        Text(subtitle, style: MHTextStyles.h1.copyWith(color: MHColors.blueDark), textAlign: TextAlign.center),
        Flexible(
          child: Stack(
            children: [
              PatternLock(
                selectedColor: MHColors.blueLight,
                notSelectedColor: MHColors.blueDark,
                pointRadius: 16,
                showInput: true,
                dimension: 3,
                relativePadding: 0.7,
                selectThreshold: 25,
                fillPoints: true,
                onInputComplete: (List<int> input) {
                  onInputComplete(input);
                },
              ),
              Visibility(
                visible: _unlocked,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: _cancelButtonEnabled ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
          children: [
            ModalButton(
              width: 220,
              text: widget.isChangingPattern ? 'CONFIRMAR' : 'DESBLOQUEAR',
              enabled: _unlocked,
              filled: true,
              onTap: () async {
                if (widget.isChangingPattern) {
                  await prefs.setString('pattern', jsonEncode(_pattern));
                }
                Dialogs.remove();
              },
            ),
            Visibility(
              visible: _cancelButtonEnabled,
              child: ModalButton(
                width: 220,
                text: 'CANCELAR',
                enabled: true,
                filled: false,
                onTap: () {
                  Dialogs.remove();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
