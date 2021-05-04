*&---------------------------------------------------------------------*
*& Report ZSCH_12_MY_LITTLE_FARM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_12_my_little_farm.
TYPE-POOLS icon.
TYPE-POOLS sym.
* Für Select-Option und RTTI
DATA: gd_beet    TYPE zsch_12_td_beet,
      gt_beete   TYPE stringtab,
      gd_nr_beet TYPE i,
      gt_frutis  TYPE stringtab,
      gt_vegis   TYPE stringtab,
      gs_plant   TYPE string.
**********************************************************************
* PARAMETERS: pa_gdat TYPE d DEFAULT '19690722'.
* Block für Gartenfreude
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-f01.
* Gartendatum
PARAMETERS: pa_gdat TYPE dats DEFAULT '19690722' OBLIGATORY MEMORY ID rid.
* Beetauswahl
SELECT-OPTIONS: so_beet FOR gd_beet.
* Ende Block Gartenfreude
SELECTION-SCREEN END OF BLOCK b1.
* Block Pflanzen
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-f02.
* früchtchen-radiobutton-gruppe
PARAMETERS: pa_fruti RADIOBUTTON GROUP plat USER-COMMAND chng.
* Block Früchtchen
SELECTION-SCREEN BEGIN OF BLOCK b21 WITH FRAME TITLE TEXT-f21.
* Früchtchenchecker
PARAMETERS: pa_stra  AS CHECKBOX,
            pa_bana  AS CHECKBOX,
            pa_jelly AS CHECKBOX.
* Ende Block Früchtchen
SELECTION-SCREEN END OF BLOCK b21.
* Grünzeug-Radiobutton-Gruppe
PARAMETERS: pa_vegi RADIOBUTTON GROUP plat.
* Block Grünzeug
SELECTION-SCREEN BEGIN OF BLOCK b22 WITH FRAME TITLE TEXT-f22.
* Gemüsechecker
PARAMETERS: pa_caro AS CHECKBOX,
            pa_cucu AS CHECKBOX,
            pa_sala AS CHECKBOX.
* Ende Block Gemüse
SELECTION-SCREEN END OF BLOCK b22.
* Ende Block Pflanzen
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON BLOCK b21."*1
  CHECK sy-ucomm <> 'CHNG'."*2
  IF pa_fruti = abap_true
  AND pa_stra = abap_false
  AND pa_bana = abap_false
  AND pa_jelly = abap_false.
    MESSAGE e002(zsch_12) WITH sy-uname.
  ENDIF.

AT SELECTION-SCREEN ON BLOCK b22.
  CHECK sy-ucomm <> 'CHNG'.
  IF pa_vegi = abap_true
    AND pa_caro = abap_false
    AND pa_cucu = abap_false
    AND pa_sala = abap_false.
    MESSAGE e002(zsch_12) WITH sy-uname.
  ENDIF.

AT SELECTION-SCREEN.
*  Alle Beet-Texte aus dem Datenelement ermitteln
  DATA(gr_beet_descr) = CAST cl_abap_elemdescr(
  cl_abap_typedescr=>describe_by_data( gd_beet ) ).
* Die Festwerte holen
  DATA(gt_beet_fixvalues) = gr_beet_descr->get_ddic_fixed_values( ).
* Was war die Aktion?
  CASE sy-ucomm.
* ...
  ENDCASE.
* Anzahl und Texte zu gewählten Beeten ermitteln
  CLEAR gt_beete.

  gd_nr_beet = 0. "Starte mit 0 ausgewählten
* Ermitteln der Texte zu Beeten, die vom Anwender gewählt wurden
  LOOP AT gt_beet_fixvalues INTO DATA(gs_beet_fixvalue) "Alle Beete
  WHERE low IN so_beet.
    ADD 1 TO gd_nr_beet.
    APPEND gs_beet_fixvalue-ddtext TO gt_beete.
  ENDLOOP.
  APPEND 'Kletterbeeren' TO gt_frutis.
  APPEND 'Winterharte Bananen' TO gt_frutis.
  APPEND 'Jelly Beans' TO gt_frutis.


* ...
* Ausgabe der Grundliste, also das Beet-Layout
END-OF-SELECTION.
* Titel setzen
  SET TITLEBAR 'TITLELIST'.
* Eine schöne Blume
  WRITE: / icon_selection AS ICON.
* Textausgabe
  WRITE: 'Gartendatum:'(t02), pa_gdat DD/MM/YYYY.
* Zeile auslassen
  SKIP.
* Für jeden Eintrag in der Beet-Tabelle ein Beet zeichnen
* mit Name des Beetes und der Pflanze
  LOOP AT gt_beete INTO DATA(gs_beet).
* Pflanze zum Beet lesen, dafür Beet-Index speichern und
* als Pflanzenindex verwenden
    DATA(gd_tabix) = sy-tabix.
* Arbeitsstruktur für Pflanzennamen initialisieren
    CLEAR gs_plant.
* Früchtchen oder Grünzeug
    IF pa_fruti = abap_true.
      READ TABLE gt_frutis INTO gs_plant INDEX gd_tabix.
    ELSEIF pa_vegi = abap_true.
      READ TABLE gt_vegis INTO gs_plant INDEX gd_tabix.
    ENDIF.
* Beet zeichnen
    PERFORM draw_beet
    USING
    gs_beet
    gs_plant.
  ENDLOOP.

START-OF-SELECTION.

  DATA(gr_beet_descr) = CAST cl_abap_elemdescr(
  cl_abap_typedescr=>describe_by_data( gd_beet ) ).

END-OF-SELECTION.

*  WRITE: / 'Gartendatum: '(t02), pa_gdat.

* Interaktion mit der Liste
AT LINE-SELECTION.
  DATA: gd_val    TYPE char80,
        gd_line   TYPE i,
        gd_offset TYPE i,
        gd_icon   TYPE icon_d.

  gd_icon = icon_selection+1(2).
* Die Informationen ermitteln, die der Anwender angeklickt hat
  GET CURSOR VALUE gd_val
  LINE gd_line
  OFFSET gd_offset.
* Blümchen malen
  sy-lisel+gd_offset(2) = gd_icon.
* Und in der Liste ändern
  MODIFY CURRENT LINE.

FORM draw_beet USING id_name TYPE string
id_pname TYPE string.
* Ein Beet
* Farbe an für Beet
  FORMAT COLOR COL_GROUP.
* Ausgefüllte Checkbox, Beet-Name und Pflanzenname
  WRITE: / sym_checkbox AS SYMBOL, id_name, id_pname.
* Farbe auf positiv für Beet
  FORMAT COLOR COL_POSITIVE.
* Der obere Rand des Beetes
  WRITE / '-------------------------------------------------------------------'.
* Vier Pflanzenreihen
  DO 4 TIMES.
* Der linke Rand
    WRITE: / '|'.
* Die Pflanzpositionen
    DO 32 TIMES.
* Ein grüner Fleck, ohne Leerzeichen,
* als Hotspot (Mauszeiger ändert sich)
      WRITE icon_oo_object AS ICON NO-GAP HOTSPOT. "NO-GAP
    ENDDO.
* Der rechte Rand
    WRITE: '|'.
  ENDDO.
* Der untere Rand
  WRITE / '-------------------------------------------------------------------'.
* Farbe aus
  FORMAT COLOR OFF.
ENDFORM.
