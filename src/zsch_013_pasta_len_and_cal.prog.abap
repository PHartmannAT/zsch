*&---------------------------------------------------------------------*
*& Report ZSCH_013_PASTA_LEN_AND_CAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_013_pasta_len_and_cal.
* Datentransportstruktur
TABLES: zsch_13_ts_ui_9000,
        zsch_13_ts_ui_9100.

DATA: ok_code LIKE sy-ucomm.

* Hier legst du Deklarationen an
START-OF-SELECTION.
* Hier programmierst du das Lesen der Daten
END-OF-SELECTION.
* Dein erster Aufruf eines Dynpros
  CALL SCREEN 9000.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'STATUS9000'.
  SET TITLEBAR 'TITLE9000'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9100 OUTPUT.
  SET PF-STATUS 'STATUS9100'.
  SET TITLEBAR 'TITLE9100'.
ENDMODULE.

MODULE user_command_9000 INPUT.
  CASE ok_code.
* Navigation zurück zur Aufrufstelle
    WHEN 'BACK'.
      SET SCREEN 0.
* Anwender hat Berechnen gewählt
    WHEN 'CALC'.
* Berechnung
      PERFORM calc_pasta_len
      USING zsch_13_ts_ui_9000-pasta_kind
      zsch_13_ts_ui_9000-pasta_weight_cooked
      CHANGING zsch_13_ts_ui_9100-pasta_len.
* Berechnung Kilokalorien
      PERFORM calc_pasta_cal
      USING zsch_13_ts_ui_9000-pasta_kind
      zsch_13_ts_ui_9000-pasta_weight_cooked
      CHANGING zsch_13_ts_ui_9100-pasta_cals.
* Ansonsten Alternativaktion
    WHEN OTHERS.
  ENDCASE.
ENDMODULE. " USER_COMMAND_9000 INPUT

FORM calc_pasta_len
USING id_kind TYPE zsch_13_ts_ui_9000-pasta_kind
id_weight TYPE zsch_13_ts_ui_9000-pasta_weight_cooked
CHANGING cd_len TYPE zsch_13_ts_ui_9100-pasta_len.
* Hilfsvariable für die Länge
  DATA: ld_len LIKE cd_len.
* Welche Art von Pasta?
  CASE id_kind.
    WHEN 'SPAGHETTI'.
      ld_len = ( id_weight / 2 ) * 25.
    WHEN 'RIGATI'.
      ld_len = ( id_weight / 6 ) * '4.2'.
* Einheitsnudel
    WHEN OTHERS.
      ld_len = 0.
  ENDCASE.
* Rückgabe
  cd_len = ld_len.
ENDFORM. " CALC_PASTA_LEN

FORM calc_pasta_cal
USING id_kind TYPE zsch_13_ts_ui_9000-pasta_kind
id_weight TYPE zsch_13_ts_ui_9000-pasta_weight_cooked
CHANGING cd_cal TYPE zsch_13_ts_ui_9100-pasta_cals.
* Hilfsvariable für die Kalorien
  DATA: ld_cal LIKE cd_cal.
* Welche Art von Pasta?
  CASE id_kind.
    WHEN 'SPAGHETTI'.
* Pro 100 g 356 kcal
      ld_cal = ( id_weight / 100 ) * 356.
    WHEN 'RIGATI'.
* Pro 100 g 245 kcal
      ld_cal = ( id_weight / 100 ) * 245.
* Einheitsnudel
    WHEN OTHERS.
      ld_cal = 0.
  ENDCASE.
* Rückgabe
  cd_cal = ld_cal.
ENDFORM. " CALC_PASTA_CAL
