*&---------------------------------------------------------------------*
*& Report ZSCH_020_DYNAMIC_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_020_dynamic_program.
*
** Datengedöns
*DATA: gt_program TYPE stringtab, "Das Programm
*      gd_prog    TYPE c LENGTH 8, "Erzeugter Name des Progrs
*      gd_msg     TYPE c LENGTH 120, "Fehlernachricht
*      gd_lin     TYPE c LENGTH 10, "Fehlerzeile im Programm
*      gd_wrd     TYPE c LENGTH 10, "Erstes fehlerhaftes Token
*      gd_off     TYPE c LENGTH 3. "Offset im Token
*
*START-OF-SELECTION.
** Programm schreiben*1
*  APPEND 'program subpool.' TO gt_program.
*  APPEND 'form hallo_schroe.' TO gt_program.
*  APPEND 'write / ''Hallo, dynamischer Schrö''.' TO gt_program.
*  APPEND 'endform.' TO gt_program.
** Programm erzeugen*2
*  GENERATE SUBROUTINE POOL gt_program "Programm
*  NAME gd_prog "Names des Progs
*  MESSAGE gd_msg "Ab hier Fehlerbehandlung
*  LINE gd_lin
*  WORD gd_wrd
*  OFFSET gd_off.
*  IF sy-subrc <> 0.
*    WRITE: / 'Fehler während der Erzeugung in Zeile',
*    gd_lin,
*    / gd_msg,
*    / 'Wort:',
*    gd_wrd,
*    'in Zeile ',
*    gd_lin.
*  ELSE.
*    PERFORM hallo_schroe IN PROGRAM (gd_prog).
*  ENDIF.

CONSTANTS: gc_rep TYPE c LENGTH 40 VALUE 'ZSCH_020_DYN'.
DATA: gt_code TYPE TABLE OF rssource-line. "Programm

START-OF-SELECTION.

  DATA gd_prog TYPE c LENGTH 30.
  DATA gt_prog TYPE stringtab.
* Name des Programms
  gd_prog = gc_rep.
* Programm schon da?
  READ REPORT gd_prog INTO gt_prog.
  IF sy-subrc = 0.
    EXIT.
  ENDIF.
* Programm aufbauen*1
  APPEND 'REPORT ZSCH_020_DYN.' TO gt_code.
  APPEND 'WRITE / ''Hallo Schrödinger''.' TO gt_code.
* Programm speichern
  INSERT REPORT gc_rep FROM gt_code.
* Programm ausführen
  SUBMIT (gc_rep) AND RETURN.
