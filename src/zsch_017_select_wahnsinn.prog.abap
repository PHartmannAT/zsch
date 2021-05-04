*&---------------------------------------------------------------------*
*& Report ZSCH_017_SELECT_WAHNSINN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_017_select_wahnsinn.
* Mit Fremdschlüsselverprobung
PARAMETERS: pa_cust TYPE zsch016address-customid.
* Intervallpflege für die Adressen-ID
DATA: ls_address TYPE zsch016address.
SELECT-OPTIONS: so_adr FOR ls_address-addressid.

START-OF-SELECTION.
  SELECT customid, vorname, nachname
    FROM zsch016customer
    INTO @DATA(ls_customer_sub)
    WHERE customid = @pa_cust.
*    WRITE: /
*    |Kunde { ls_customer_sub-customid } : { ls_customer_sub-vorname } { ls_customer_sub-nachname } |.
    WRITE: /
    'Kunde',
    ls_customer_sub-customid,
    ':',
    ls_customer_sub-vorname,
    ls_customer_sub-nachname.
    SELECT addressid, plz, ort, strasse
      FROM zsch016address
      INTO  @DATA(ls_address_sub)
      WHERE customid = @ls_customer_sub-customid
      AND   addressid IN @so_adr.
*      WRITE / |Adresse { ls_address_sub-addressid } : { ls_address_sub-plz } { ls_address_sub-ort } { ls_address_sub-strasse }|.
      WRITE: /
      'Adresse',
      ls_address_sub-addressid,
      ':',
      ls_address_sub-plz,
      ls_address_sub-ort,
      ls_address_sub-strasse.
    ENDSELECT.
  ENDSELECT.
