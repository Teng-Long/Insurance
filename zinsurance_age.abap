*&---------------------------------------------------------------------*
*& Report  ZINSURENCE_AGE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zinsurence_age.
PARAMETERS :p_idate TYPE icl_startdate,
            p_cdate TYPE icl_startdate,
            p_bdate TYPE /nsl/cm_birthday.

DATA:gv_age            TYPE /nsl/icl_insurance_age,
     gv_incpetion_date TYPE icl_inception1.
DATA lv_inception_year TYPE i.
DATA lv_incpetion_date TYPE sy-datum.
DATA lv_delta_year TYPE vtbbewe-atage.
DATA lv_delta_month TYPE vtbbewe-atage.
DATA lv_delta_days  TYPE tfmatage.

CONVERT DATE p_idate
        INTO TIME STAMP gv_incpetion_date TIME ZONE sy-zonlo.

*CALL METHOD /nsl/cl_icl_util=>calculate_insurance_age
*  EXPORTING
*    iv_inception_date = gv_incpetion_date
*    iv_incident_date  = p_cdate
*    iv_birthday       = p_bdate
*  IMPORTING
*    ev_insurance_age  = gv_age.
*
*WRITE:gv_age.

IF p_bdate IS INITIAL OR gv_incpetion_date IS INITIAL OR p_cdate IS INITIAL.
  RETURN.
ENDIF.

*    write lv_incpetion_date to lv_incpetion_date(15).

CONVERT TIME STAMP gv_incpetion_date TIME ZONE sy-zonlo
        INTO DATE lv_incpetion_date.

*    REPLACE ALL OCCURRENCES OF '.' IN lv_incpetion_date WITH ''.

CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
  EXPORTING
    i_date_from    = p_bdate
*   I_KEY_DAY_FROM =
    i_date_to      = lv_incpetion_date
*   I_KEY_DAY_TO   =
    i_flg_separate = iscm_x
  IMPORTING
    e_days         = lv_delta_days
    e_months       = lv_delta_month
    e_years        = lv_delta_year.
IF lv_delta_days > 0.
  lv_delta_year = lv_delta_year + 1.
ENDIF.

IF lv_delta_month MOD 12 > 6."
  lv_delta_year = lv_delta_year + 1.
ENDIF.

*    IF ( lv_incpetion_date+4(2) - p_bdate+4(2) > 6 )  OR ( ( lv_incpetion_date+4(2) -  p_bdate+4(2) = 6  )
*      AND ( lv_incpetion_date+6(2) >= p_bdate+6(2) ) ).
*      lv_inception_year = lv_incpetion_date+0(4) - p_bdate+0(4) + 1.
*    ELSE.
*      lv_inception_year = lv_incpetion_date+0(4) - p_bdate+0(4).
*    ENDIF.

IF p_cdate+4(4) >=  lv_incpetion_date+4(4).
  gv_age = p_cdate+0(4) - lv_incpetion_date+0(4) + lv_delta_year .
ELSE.
  gv_age = p_cdate+0(4) - lv_incpetion_date+0(4) - 1 + lv_delta_year.
ENDIF.

WRITE gv_age.
