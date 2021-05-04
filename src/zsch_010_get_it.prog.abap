*&---------------------------------------------------------------------*
*& Report ZSCH_010_GET_IT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSCH_010_GET_IT.

DATA: gr_client    TYPE REF TO if_http_client, "Client fu#r Anfrage*1
      gd_host      TYPE string VALUE 'openlibrary.org', "Datenquelle*2
      gd_service   TYPE string VALUE '80', "Standard-HTTP-Port*3
      gd_path      TYPE string VALUE
           '/api/books?bibkeys=ISBN:9780330258647&jscmd=data&format=json',
      gd_errortext TYPE string, "Fehlertext der Anfrage
      gd_timeout   TYPE i, "Langläufer?
      gd_subrc     LIKE sy-subrc. "Fehler bei Anfrage
* Datenausgabe
DATA: gd_data TYPE string. "Die Daten vom Response
DATA: gt_fields TYPE tihttpnvp, "Felder aus dem Header
      gs_field  LIKE LINE OF gt_fields.
DATA: gt_data TYPE stringtab, "Zerhackte Daten
      gs_data LIKE LINE OF gt_data.

****************************************************************
* Hier beginnt die Party mit dem Client
START-OF-SELECTION.
* Ein Client-Objekt fu#r die Kommunikation instanziieren
  CALL METHOD cl_http_client=>create
    EXPORTING
      host               = gd_host
      service            = gd_service
      scheme             = cl_http_client=>schemetype_http "HTTP=1
    IMPORTING
      client             = gr_client
    EXCEPTIONS
      argument_not_found = 1
      internal_error     = 2
      plugin_not_active  = 3
      OTHERS             = 4.
* Fehlerbehandlung
  IF sy-subrc <> 0.
    WRITE: / 'Die Anlage des Clients schlug fehlt, subrc = ',

    sy-subrc.
* Ende der Verarbeitung
    EXIT.
  ENDIF.
* Die Request-Methode auf GET setzen
  CALL METHOD gr_client->request->set_method(
    if_http_request=>co_request_method_get ).
* Protokollversion HTTP/1.0 setzen
  gr_client->request->set_version(
  if_http_request=>co_protocol_version_1_0 ).
* Die Request-URI festlegen
  cl_http_utility=>set_request_uri(
  request = gr_client->request
  uri = gd_path ).

****************************************************************
* Senden des Requests
  CALL METHOD gr_client->send
    EXPORTING
      timeout                    = gd_timeout
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
* Fehlerbehandlung
  IF sy-subrc <> 0.
* Ermittlung des Fehlers
    CALL METHOD gr_client->get_last_error
      IMPORTING
        code    = gd_subrc
        message = gd_errortext.
    WRITE: / 'Kommunikationsfehler beim send',
    / 'Fehlercode: ', gd_subrc, 'Fehlernachricht: ',
    gd_errortext.
* Ende der Verarbeitung
    EXIT.
  ENDIF.
****************************************************************
* Empfangen der Ergebnisse
  CALL METHOD gr_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
* Fehlerbehandlung
  IF sy-subrc <> 0.
    CALL METHOD gr_client->get_last_error
      IMPORTING
        code    = gd_subrc
        message = gd_errortext.
    WRITE: / 'Kommunikationsfehler beim receive',
    / 'Fehlercode: ', gd_subrc, 'Fehlernachricht: ',
    gd_errortext.
* Ende der Verarbeitung
    EXIT.
  ENDIF.

****************************************************************
* Ausgabe der Daten
* Header-Daten der Übertragung
CALL METHOD gr_client->response->get_header_fields
CHANGING
fields = gt_fields.
* Ausgabe der Header Fields auf Standardliste
  ULINE.
  WRITE: / 'Header Fields'.
  ULINE.
  LOOP AT gt_fields INTO gs_field.
    WRITE: / 'header_name', gs_field-name,
    'header_value', gs_field-value.
  ENDLOOP.
* Response-Daten ermitteln aus Response-Objekt
  gd_data = gr_client->response->get_cdata( ).
* Einfache Ausgabe
  ULINE.
  WRITE: /'Data'.
  ULINE.
  SPLIT gd_data AT '{' INTO TABLE gt_data.
  LOOP AT gt_data INTO gs_data.
    WRITE: / gs_data.
  ENDLOOP.
****************************************************************
* Schließen der Verbindung
  CALL METHOD gr_client->close
    EXCEPTIONS
      http_invalid_state = 1
      OTHERS             = 2.
* Fehlerbehandlung
  IF sy-subrc <> 0.
    CALL METHOD gr_client->get_last_error
      IMPORTING
        code    = gd_subrc
        message = gd_errortext.
    WRITE: / 'Kommunikationsfehler beim close',
    / 'Fehlercode: ', gd_subrc, 'Fehlernachricht: ',
    gd_errortext.
* Ende der Verarbeitung
    EXIT.
  ENDIF.
