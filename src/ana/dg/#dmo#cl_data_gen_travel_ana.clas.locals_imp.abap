
CLASS lcl_travel_data_generator DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES /dmo/if_data_generator.

    TYPES: BEGIN OF status_structure,
    overall_status TYPE c LENGTH 1,
    END OF status_structure.

    TYPES currency_code_type TYPE STANDARD TABLE OF I_CurrencyStdVH WITH KEY Currency.
    TYPES country_type       TYPE STANDARD TABLE OF I_CountryText WITH KEY Country.
    TYPES travel_type        TYPE STANDARD TABLE OF /dmo/a_trvl_ana WITH KEY travel_uuid.
    TYPES status_type        TYPE STANDARD TABLE OF status_structure WITH KEY overall_status.


  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS numberrange_interval TYPE cl_numberrange_runtime=>nr_interval VALUE '01'.
    CONSTANTS numberrange_object   TYPE cl_numberrange_runtime=>nr_object   VALUE '/DMO/TRAVL' ##NO_TEXT.

    CLASS-DATA ran_agency             TYPE REF TO cl_abap_random_int.
    CLASS-DATA ran_travel_description TYPE REF TO cl_abap_random_int.
    CLASS-DATA ran_currency_code      TYPE REF TO cl_abap_random_int.
    CLASS-DATA ran_total_price_float  TYPE REF TO cl_abap_random_decfloat16.
    CLASS-DATA ran_total_price_int    TYPE REF TO cl_abap_random_int.
    CLASS-DATA ran_countryname        TYPE REF TO cl_abap_random_int.
    CLASS-DATA currency_codes          TYPE currency_code_type.
    CLASS-DATA countryname            TYPE country_type.
    CLASS-DATA data                   TYPE travel_type.
    CLASS-DATA ran_booking_fee_int    TYPE REF TO cl_abap_random_int.
    CLASS-DATA overall_status TYPE status_type.
    CLASS-DATA ran_overall_status     TYPE REF TO cl_abap_random_int.

    CLASS-METHODS get_data
      RETURNING VALUE(result) TYPE travel_type.

    CLASS-METHODS build_content.
    CLASS-METHODS build_dependend_content.
    CLASS-METHODS build_uuid.
    CLASS-METHODS build_semantic_key.
    CLASS-METHODS build_misc_fields.
    CLASS-METHODS build_admin_fields.

    CLASS-METHODS set_numberrange.

    CLASS-METHODS generate_description
      RETURNING VALUE(result) TYPE /dmo/a_trvl_ana-description.

    CLASS-METHODS build_currency_code
      RETURNING VALUE(result) TYPE currency_code_type.

    CLASS-METHODS build_country
      RETURNING VALUE(result) TYPE country_type.

    CLASS-METHODS delete_content.

    CLASS-METHODS insert_content.

    CLASS-METHODS build_overall_status
      RETURNING VALUE(result) TYPE status_type.

ENDCLASS.






CLASS lcl_travel_data_generator IMPLEMENTATION.
  METHOD /dmo/if_data_generator~create.

    DATA(text_output) = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_text_output_instance( out ).
    ##NO_TEXT
    text_output->print_title( 'Travel ANA' ).

    text_output->print_delete( ).
    delete_content( ).

    text_output->print_build( ).
    set_numberrange( ).
    get_data( ).

    text_output->print_insert( ).
    insert_content( ).

    text_output->print_done( ).
  ENDMETHOD.

  METHOD delete_content.

    DELETE FROM /dmo/a_trvl_ana.                        "#EC CI_NOWHERE

  ENDMETHOD.

  METHOD set_numberrange.
    /dmo/cl_flight_data_generator=>reset_numberrange_interval(
      EXPORTING
        numberrange_object   = numberrange_object
        numberrange_interval = numberrange_interval
        fromnumber           = CONV cl_numberrange_intervals=>nr_nriv_line-fromnumber( '00000001' )
        tonumber             = CONV cl_numberrange_intervals=>nr_nriv_line-tonumber( CONV /dmo/travel_id( /dmo/if_flight_legacy=>late_numbering_boundary - 1 ) ) ).
  ENDMETHOD.

  METHOD get_data.
    IF data IS INITIAL.
      build_content( ).
    ENDIF.
    RETURN data.
  ENDMETHOD.

  METHOD build_content.
    build_dependend_content( ).

    build_uuid( ).
    build_semantic_key( ).

    build_misc_fields( ).
    build_admin_fields( ).
  ENDMETHOD.

  METHOD build_dependend_content.
    CONSTANTS start_at_1      TYPE i VALUE 1.
    CONSTANTS seed            TYPE i VALUE 42.
    CONSTANTS description_max TYPE i VALUE 9.
    CONSTANTS price_int_min   TYPE i VALUE 1000.
    CONSTANTS price_int_max   TYPE i VALUE 99999.
    CONSTANTS fee_int_max     TYPE i VALUE 150.
    CONSTANTS fee_int_min     TYPE i VALUE 1.



    currency_codes = build_currency_code( ).
    ran_currency_code = cl_abap_random_int=>create( min = start_at_1
                                                       max = lines( currency_codes ) ).

    countryname = build_country( ).
    ran_countryname = cl_abap_random_int=>create( min = start_at_1
                                                     max = lines( countryname ) ).

    ran_travel_description = cl_abap_random_int=>create( min = start_at_1
                                                            max = description_max ).

    ran_total_price_float = cl_abap_random_decfloat16=>create( seed = seed ).
    ran_total_price_int = cl_abap_random_int=>create( min = price_int_min
                                                         max = price_int_max ).
    ran_booking_fee_int = cl_abap_random_int=>create( min = fee_int_min
                                                         max = fee_int_max ).
    overall_status = build_overall_status(  ).
    ran_overall_status = cl_abap_random_int=>create( min = start_at_1
                                                       max = lines( overall_status ) ).
  ENDMETHOD.

  METHOD build_uuid.
    CONSTANTS travel_amount TYPE i VALUE 100.

    DATA travel_uuid TYPE sysuuid_x16.
    DATA error       TYPE REF TO cx_uuid_error.

    DO travel_amount TIMES.

      TRY.
          travel_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO error.
          " Should not happen.  If so, something is wrong
          RAISE SHORTDUMP error.
      ENDTRY.

      APPEND VALUE /dmo/a_trvl_ana( travel_uuid = travel_uuid ) TO data.
    ENDDO.

  ENDMETHOD.

  METHOD build_semantic_key.
    DATA data_lines          TYPE i.
    DATA numberrange_key     TYPE cl_numberrange_runtime=>nr_number.
    DATA error               TYPE REF TO cx_number_ranges.
    DATA maximum TYPE i.
    DATA current TYPE i.

    data_lines = lines( data ).

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING nr_range_nr = numberrange_interval
                    object      = numberrange_object
                    quantity    = CONV cl_numberrange_runtime=>nr_quantity( data_lines )
          IMPORTING number      = numberrange_key ).
      CATCH cx_number_ranges INTO error.
        " Should not happen.  If so, something is wrong
        RAISE SHORTDUMP error.
    ENDTRY.

    maximum = CONV i( numberrange_key+2 ).
    current = maximum - data_lines.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<travel>).
      current += 1.
      <travel>-travel_id = CONV #( current ).
    ENDLOOP.
  ENDMETHOD.

  METHOD generate_description.
    DATA(person) = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_name_gen_instance( )->generate( ).
    DATA(country) = countryname[ ran_countryname->get_next( ) ]-CountryName. "#EC CI_NOORDER

    result = SWITCH /dmo/a_trvl_ana-description(
                               ran_travel_description->get_next( )
                               WHEN 1 THEN |Business Trip for { person-first-salutation } { person-last }|
                               WHEN 2 THEN |Vacation for { person-first-salutation } { person-last }|
                               WHEN 3 THEN |Business Trip to { country }|
                               WHEN 4 THEN |Vacation to { country }|
                               WHEN 5 THEN |Visiting { person-first-salutation } { person-last }|
                               WHEN 6 THEN |Business Trip|
                               ELSE        |Vacation| )
                        ##NO_TEXT.
  ENDMETHOD.

  METHOD build_misc_fields.
    LOOP AT data ASSIGNING FIELD-SYMBOL(<travel>).
      DATA(date_generator) = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_date_gen_instance( ).


      <travel>-total_price   = ran_total_price_float->get_next( ) + ran_total_price_int->get_next( ).
      <travel>-booking_fee   = ran_total_price_float->get_next( ) + ran_booking_fee_int->get_next( ).
      <travel>-currency_code = currency_codes[ ran_currency_code->get_next( ) ]-Currency. "#EC CI_NOORDER
      <travel>-begin_date = date_generator->generate_date( ).
      <travel>-end_date   = date_generator->generate_new_date_with_offset( <travel>-begin_date ).
      <travel>-description = generate_description( ).
      <travel>-overall_status = overall_status[ ran_overall_status->get_next(  ) ]-Overall_Status.
    ENDLOOP.
  ENDMETHOD.

  METHOD build_admin_fields.
    DATA: admin_field_generator TYPE REF TO /dmo/if_admin_field_generator.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<travel>).
      admin_field_generator = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_adm_field_gen_instance( <travel>-begin_date ).

      <travel>-local_created_at      = admin_field_generator->generate_local_created_at( ).
      <travel>-last_changed_at       = admin_field_generator->generate_last_changed_at( ).
      <travel>-local_last_changed_at = admin_field_generator->generate_local_last_changed_at( ).
      <travel>-local_created_by      = admin_field_generator->generate_local_created_by( ).
      <travel>-local_last_changed_by = admin_field_generator->generate_local_last_changed_by( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD build_currency_code.
    SELECT Currency FROM I_CurrencyStdVH INTO TABLE @result. "#EC CI_NOWHERE
  ENDMETHOD.

  METHOD build_overall_status.
    result = VALUE #( ( overall_status = 'A' )
                      ( overall_status = 'X' )
                      ( overall_status = 'O' ) ).
  ENDMETHOD.
  METHOD build_country.
    SELECT FROM I_CountryText FIELDS country, countryname WHERE language = 'E' INTO TABLE @result.
  ENDMETHOD.

  METHOD insert_content.
    INSERT /dmo/a_trvl_ana FROM TABLE @data.
  ENDMETHOD.

ENDCLASS.
