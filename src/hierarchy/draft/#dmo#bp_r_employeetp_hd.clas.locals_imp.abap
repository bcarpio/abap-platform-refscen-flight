CLASS ltc_general DEFINITION DEFERRED FOR TESTING.

"! Implentation of general functionality such as basic validations and determinations.
CLASS lhc_general DEFINITION INHERITING FROM cl_abap_behavior_handler FRIENDS ltc_general.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF state_areas,
        validation_currency_exists TYPE string VALUE 'VALIDATIONCURRENCYEXISTS' ##NO_TEXT,
        validation_name_given      TYPE string VALUE 'VALIDATIONNAMEGIVEN' ##NO_TEXT,
        validation_salary_positive TYPE string VALUE 'VALIDATIONSALARYPOSITIVE' ##NO_TEXT,
      END OF state_areas.

    METHODS validationcurrencyexists FOR VALIDATE ON SAVE
      IMPORTING keys FOR employee~validationcurrencyexists.

    METHODS validationnamegiven FOR VALIDATE ON SAVE
      IMPORTING keys FOR employee~validationnamegiven.

    METHODS validationsalarypositive FOR VALIDATE ON SAVE
      IMPORTING keys FOR employee~validationsalarypositive.

ENDCLASS.

CLASS lhc_general IMPLEMENTATION.

  METHOD validationcurrencyexists.
    READ ENTITIES OF /dmo/r_agencytp_hd IN LOCAL MODE
      ENTITY employee
          FIELDS ( salarycurrency )
          WITH CORRESPONDING #( keys )
        RESULT DATA(employees)
      ENTITY employee BY \_agency
          FROM CORRESPONDING #( keys )
        LINK DATA(employee_agency_links).

    DATA: currencies TYPE SORTED TABLE OF i_currency WITH UNIQUE KEY currency.

    currencies = CORRESPONDING #(  employees DISCARDING DUPLICATES MAPPING currency = salarycurrency EXCEPT * ).
    DELETE currencies WHERE currency IS INITIAL.

    IF currencies IS NOT INITIAL.
      SELECT FROM i_currency FIELDS currency
        FOR ALL ENTRIES IN @currencies
        WHERE currency = @currencies-currency
        INTO TABLE @DATA(currency_db).
    ENDIF.


    LOOP AT employees INTO DATA(employee).
      APPEND VALUE #(
          %tky               = employee-%tky
          %state_area        = state_areas-validation_currency_exists
        ) TO reported-employee.
      IF employee-salarycurrency IS INITIAL.
        APPEND VALUE #( %tky = employee-%tky ) TO failed-employee.
        APPEND VALUE #(
            %tky                    = employee-%tky
            %state_area             = state_areas-validation_currency_exists
            %element-salarycurrency = if_abap_behv=>mk-on
            %path                   = VALUE #(
                agency-%tky = employee_agency_links[
                    KEY id
                    source-%tky = employee-%tky
                  ]-target-%tky
              )
            %msg                    = NEW /dmo/cm_flight_messages(
                textid    = /dmo/cm_flight_messages=>currency_required
                severity  = if_abap_behv_message=>severity-error
              )
          ) TO reported-employee.
      ELSEIF NOT line_exists( currency_db[ currency = employee-salarycurrency ] ).
        APPEND VALUE #( %tky = employee-%tky ) TO failed-employee.
        APPEND VALUE #(
            %tky                    = employee-%tky
            %state_area             = state_areas-validation_currency_exists
            %element-salarycurrency = if_abap_behv=>mk-on
            %path                   = VALUE #(
                agency-%tky = employee_agency_links[
                    KEY id
                    source-%tky = employee-%tky
                  ]-target-%tky
              )
            %msg                    = NEW /dmo/cm_flight_messages(
                textid        = /dmo/cm_flight_messages=>currency_not_existing
                severity      = if_abap_behv_message=>severity-error
                currency_code = employee-salarycurrency
              )
          ) TO reported-employee.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validationnamegiven.
    READ ENTITIES OF /dmo/r_agencytp_hd IN LOCAL MODE
      ENTITY employee
          FIELDS ( firstname lastname )
          WITH CORRESPONDING #( keys )
        RESULT DATA(employees)
      ENTITY employee BY \_agency
          FROM CORRESPONDING #( keys )
        LINK DATA(employee_agency_links).

    LOOP AT employees INTO DATA(employee).
      APPEND VALUE #(
          %tky               = employee-%tky
          %state_area        = state_areas-validation_name_given
        ) TO reported-employee.
      IF employee-firstname IS INITIAL AND employee-lastname IS INITIAL.
        APPEND VALUE #( %tky = employee-%tky ) TO failed-employee.
        APPEND VALUE #(
            %tky               = employee-%tky
            %state_area        = state_areas-validation_name_given
            %element-firstname = if_abap_behv=>mk-on
            %element-lastname  = if_abap_behv=>mk-on
            %path              = VALUE #(
                agency-%tky = employee_agency_links[
                    KEY id
                    source-%tky = employee-%tky
                  ]-target-%tky
              )
            %msg               = NEW /dmo/cx_hierarchy(
                textid    = /dmo/cx_hierarchy=>names_given
                severity  = if_abap_behv_message=>severity-error
              )
          ) TO reported-employee.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validationsalarypositive.
    READ ENTITIES OF /dmo/r_agencytp_hd IN LOCAL MODE
      ENTITY employee
          FIELDS ( salary )
          WITH CORRESPONDING #( keys )
        RESULT DATA(employees)
      ENTITY employee BY \_agency
          FROM CORRESPONDING #( keys )
        LINK DATA(employee_agency_links).

    LOOP AT employees INTO DATA(employee).
      APPEND VALUE #(
          %tky               = employee-%tky
          %state_area        = state_areas-validation_salary_positive
        ) TO reported-employee.
      IF employee-salary <= '0'.
        APPEND VALUE #( %tky = employee-%tky ) TO failed-employee.
        APPEND VALUE #(
            %tky            = employee-%tky
            %state_area     = state_areas-validation_salary_positive
            %element-salary = if_abap_behv=>mk-on
            %path           = VALUE #(
                agency-%tky = employee_agency_links[
                    KEY id
                    source-%tky = employee-%tky
                  ]-target-%tky
              )
            %msg            = NEW /dmo/cx_hierarchy(
                textid    = /dmo/cx_hierarchy=>invalid_salary
                severity  = if_abap_behv_message=>severity-error
              )
          ) TO reported-employee.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_hierarchy_operation DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES:
      copy_keys       TYPE TABLE FOR ACTION IMPORT /DMO/R_EMPLOYEETP_HD~copy,
      mapped          TYPE TABLE FOR MAPPED /DMO/R_EMPLOYEETP_HD,
      failed          TYPE TABLE FOR FAILED /DMO/R_EMPLOYEETP_HD,
      reported        TYPE TABLE FOR REPORTED EARLY /DMO/R_EMPLOYEETP_HD,
      failed_agencies TYPE TABLE FOR FAILED /DMO/R_AGENCYTP_HD.

    TYPES BEGIN OF parent_copy_map.
    TYPES:
      agency        TYPE /DMO/R_AGENCYTP_HD-agency,
      employee      TYPE /DMO/R_EMPLOYEETP_HD-employee,
      is_draft      TYPE abp_behv_flag,
      copy_employee TYPE /DMO/R_EMPLOYEETP_HD-employee.
    TYPES END OF parent_copy_map.

    TYPES parents_copy_map TYPE SORTED TABLE OF parent_copy_map WITH UNIQUE KEY agency employee is_draft.

    METHODS copy FOR MODIFY IMPORTING keys FOR ACTION employee~copy.

    METHODS _copy_recursion IMPORTING keys                   TYPE copy_keys
                                      parents_copy_map_param TYPE parents_copy_map OPTIONAL
                            EXPORTING mapped_employees       TYPE mapped
                                      failed_employees       TYPE failed
                                      reported_employees     TYPE reported.
ENDCLASS.

CLASS lhc_hierarchy_operation IMPLEMENTATION.
  METHOD copy.

    _copy_recursion( EXPORTING keys = keys
                     IMPORTING mapped_employees   = mapped-employee
                               failed_employees   = failed-employee
                               reported_employees = reported-employee ).

  ENDMETHOD.

  METHOD _copy_recursion.

  CONSTANTS: my_cid_kid TYPE abp_behv_cid VALUE 'My%CID_KID' ##NO_TEXT.

    DATA:
      employees_cba    TYPE TABLE FOR CREATE /DMO/R_AGENCYTP_HD\_employee,
      employees_rba    TYPE TABLE FOR READ IMPORT /DMO/R_EMPLOYEETP_HD\_employee,
      employee_rba     LIKE LINE OF employees_rba,
      parents_copy_map TYPE parents_copy_map.

    FIELD-SYMBOLS <control> TYPE x.

    CLEAR: mapped_employees, failed_employees.

    READ ENTITY IN LOCAL MODE /DMO/R_EMPLOYEETP_HD
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_sources)
    REPORTED DATA(reported_source)
    FAILED DATA(failed_source).


    LOOP AT  keys INTO DATA(key).
       READ TABLE keys ASSIGNING FIELD-SYMBOL(<dupl_key>) WITH KEY id COMPONENTS %tky = key-%tky .

        IF <dupl_key>-%cid <> key-%cid.
          failed_source-employee =  VALUE #( (  %fail    =  VALUE #( cause = if_abap_behv=>cause-unspecific )
                                                %cid     = key-%cid
                                                Agency   = key-Agency
                                                Employee = key-Employee ) ).

          INSERT LINES OF  failed_source-employee INTO TABLE failed_employees.
          CLEAR failed_source.

          APPEND VALUE #(  %cid = key-%cid
                           %tky = key-%tky
                           %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error ) ) TO reported_source-employee.

          INSERT LINES OF  reported_source-employee INTO TABLE reported_employees.
          CLEAR reported_source.

      ELSE.

        READ TABLE result_sources ASSIGNING FIELD-SYMBOL(<source>) WITH KEY id COMPONENTS %tky = key-%tky .

        IF sy-subrc <> 0.
          failed_source-employee =  VALUE #( (  %fail    =  VALUE #( cause = if_abap_behv=>cause-unspecific )
                                                %cid     = key-%cid
                                                Agency   = key-Agency
                                                Employee = key-Employee )  ).

          INSERT LINES OF  failed_source-employee INTO TABLE failed_employees.
          CLEAR failed_source.

          APPEND VALUE #( %cid     = key-%cid
                          %tky     = key-%tky
                          %msg     = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error ) ) TO reported_source-employee.

          INSERT LINES OF reported_source-employee INTO TABLE reported_employees.
          CLEAR reported_source.

        ENDIF.

      ENDIF.

    ENDLOOP.

    READ ENTITY IN LOCAL MODE /DMO/R_EMPLOYEETP_HD
      BY \_agency
      FIELDS ( agency ) WITH CORRESPONDING #( result_sources )
    LINK DATA(directory_links)
    RESULT DATA(result_rba)
    REPORTED DATA(reported_rba)
    FAILED failed_source.

    INSERT LINES OF  failed_source-employee INTO TABLE failed_employees.

    LOOP AT directory_links ASSIGNING FIELD-SYMBOL(<directory_link>).

      ASSIGN employees_cba[ KEY id %tky = <directory_link>-target-%tky  ] TO FIELD-SYMBOL(<cba>).

      IF sy-subrc <> 0.
        INSERT VALUE #( %tky = <directory_link>-target-%tky ) INTO TABLE employees_cba ASSIGNING <cba>.
      ENDIF.

      ASSIGN result_sources[ KEY id %tky = <directory_link>-source-%tky ] TO FIELD-SYMBOL(<source_directory>).
      ASSERT sy-subrc = 0.

      INSERT VALUE #( %data = CORRESPONDING #( <source_directory> )  ) INTO TABLE <cba>-%target ASSIGNING FIELD-SYMBOL(<cba_target>).

      IF parents_copy_map_param IS SUPPLIED.
        ASSIGN parents_copy_map_param[   agency   = <source_directory>-agency
                                         employee = <source_directory>-manager
                                         is_draft = <source_directory>-%is_draft ] TO FIELD-SYMBOL(<parent_copy_map>).
        ASSERT sy-subrc = 0.
        <cba_target>-manager = <parent_copy_map>-copy_employee.

      ELSE.
        CLEAR <cba_target>-manager.
      ENDIF.

      employee_rba-%tky = <source_directory>-%tky.
      <cba_target>-%cid = keys[ KEY id %tky = <source_directory>-%tky ]-%cid.
      <cba_target>-%is_draft = <source_directory>-%is_draft.

      " business logic: fields to be copied
      <cba_target>-firstname          = <source_directory>-firstname.
      <cba_target>-lastname           = <source_directory>-lastname.
      <cba_target>-salary             = <source_directory>-salary.
      <cba_target>-salarycurrency     = <source_directory>-salarycurrency.
      <cba_target>-siblingordernumber = <source_directory>-siblingordernumber.
      "  business logic end

      ASSIGN <cba_target>-%control TO <control> CASTING.
      CLEAR <control> WITH if_abap_behv=>mk-on IN BYTE MODE. "as long as there is no selective information, all elements are marked
      CLEAR: <cba_target>-%control-agency, <cba_target>-%control-employee.
      INSERT employee_rba INTO TABLE employees_rba.


    ENDLOOP.

    READ ENTITY IN LOCAL MODE /DMO/R_EMPLOYEETP_HD
      BY \_employee FROM employees_rba
    LINK DATA(children_links)
    RESULT DATA(result_rba_children)
    FAILED DATA(failed_rba_children)
    REPORTED DATA(reported_rba_children).


    MODIFY ENTITY IN LOCAL MODE /DMO/R_AGENCYTP_HD
      CREATE BY \_employee FROM employees_cba
    MAPPED DATA(mapped_create)
    FAILED DATA(failed_create)
    REPORTED DATA(reported_create).


    LOOP AT failed_create-employee ASSIGNING FIELD-SYMBOL(<failed>).
      DELETE children_links USING KEY draft WHERE source-%tky = <failed>-%tky.
    ENDLOOP.


    IF NOT parents_copy_map_param IS SUPPLIED.
      mapped_employees = mapped_create-employee.
    ENDIF.

    IF result_rba_children IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT employees_rba ASSIGNING FIELD-SYMBOL(<rba>).
      ASSIGN mapped_create-employee[ KEY cid COMPONENTS %cid = keys[ KEY id %tky = <rba>-%tky ]-%cid ] TO FIELD-SYMBOL(<mapped>).

      CHECK sy-subrc = 0.
      ASSERT <mapped>-agency    = <rba>-agency AND <mapped>-%is_draft = <rba>-%is_draft.

      INSERT VALUE #( agency      = <rba>-agency
                      employee    = <rba>-employee
                      is_draft    = <rba>-%is_draft
                      copy_employee = <mapped>-employee ) INTO TABLE parents_copy_map.
    ENDLOOP.


    _copy_recursion( keys = VALUE #( FOR <child> IN result_rba_children INDEX INTO lv_index
                                   ( %cid = my_cid_kid && lv_index  %tky = <child>-%tky ) )
                     parents_copy_map_param = parents_copy_map ).

  ENDMETHOD.
ENDCLASS.
