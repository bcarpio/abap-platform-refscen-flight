CLASS lcl_agency_data_generator DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES /dmo/if_data_generator.

    TYPES agency_type TYPE STANDARD TABLE OF /dmo/a_agncy_xbo WITH KEY agency_uuid.

    CLASS-METHODS get_data
      RETURNING VALUE(result) TYPE agency_type.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS agency_minimum TYPE /dmo/agency_id VALUE '070001'.
    CONSTANTS agency_maximum TYPE /dmo/agency_id VALUE '079999'.

    CLASS-DATA numberrange_interval TYPE cl_numberrange_runtime=>nr_interval VALUE '01'.
    CLASS-DATA numberrange_object   TYPE cl_numberrange_runtime=>nr_object   VALUE '/DMO/AGNCY' ##NO_TEXT.
    CLASS-DATA data                 TYPE agency_type.

    CLASS-METHODS set_numberrange.
    CLASS-METHODS delete_content.
    CLASS-METHODS build_content.
    CLASS-METHODS build_agency_skeleton.
    CLASS-METHODS build_uuid.
    CLASS-METHODS build_semantic_key.
    CLASS-METHODS insert_content.
    CLASS-METHODS build_admin_fields.

ENDCLASS.

CLASS lcl_agency_data_generator IMPLEMENTATION.

  METHOD get_data.
    IF data IS INITIAL.
      build_content( ).
    ENDIF.

    RETURN data.
  ENDMETHOD.

  METHOD /dmo/if_data_generator~create.
    DATA(text_output) = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_text_output_instance( out ).
    ##NO_TEXT
    text_output->print_title( 'Agency XBO' ).

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
    DELETE FROM /dmo/d_agncy_xbo. "#EC CI_NOWHERE
    DELETE FROM /dmo/a_agncy_xbo. "#EC CI_NOWHERE
  ENDMETHOD.

  METHOD set_numberrange.
    /dmo/cl_flight_data_generator=>reset_numberrange_interval(
        numberrange_object   = numberrange_object
        numberrange_interval = numberrange_interval
        fromnumber           = CONV cl_numberrange_intervals=>nr_nriv_line-fromnumber( agency_minimum )
        tonumber             = CONV cl_numberrange_intervals=>nr_nriv_line-tonumber(   agency_maximum )
      ).
  ENDMETHOD.

  METHOD build_content.
    build_agency_skeleton( ).

    build_uuid( ).
    build_semantic_key( ).
    build_admin_fields( ).
  ENDMETHOD.

  METHOD build_agency_skeleton.
    data = VALUE #( ( name         = 'Sunshine Travel'
                      city         = 'Rochester                '
                      country_code = 'US '
                      web_address  = 'http://www.sunshine-travel.sap               ' )
                    ( name         = 'Fly High'
                      city         = 'Duesseldorf               '
                      country_code = 'DE '
                      web_address  = 'http://www.flyhigh.sap                       ' )
                    ( name         = 'Happy Hopping'
                      city         = 'Berlin                   '
                      country_code = 'DE '
                      web_address  = 'http://www.haphop.sap                        ' )
                    ( name         = 'Pink Panther'
                      city         = 'Frankfurt                '
                      country_code = 'DE '
                      web_address  = 'http://www.pinkpanther.sap' )
                    ( name         = 'Your Choice'
                      city         = 'Nuernberg'
                      country_code = 'DE'
                      web_address  = 'http://www.yc.sap' )
                    ( name         = 'Bella Italia'
                      city         = 'Roma'
                      country_code = 'IT'
                      web_address  = 'http://www.tours.it/Adventure/' )
                    ( name         = 'Hot Socks Travel'
                      city         = 'Sydney'
                      country_code = 'AU '
                      web_address  = 'http://www.hst.co.au' )
                    ( name         = 'Burns Nuclear'
                      city         = 'Singapore'
                      country_code = 'SG'
                      web_address  = 'http://www.burns-burns-burns.sg' )
                    ( name         = 'Honauer Reisen GmbH'
                      city         = 'Neumarkt'
                      country_code = 'AT'
                      web_address  = 'http://www.honauer.at' )
                    ( name         = 'Travel from Walldorf'
                      city         = 'Berlin                   '
                      country_code = 'DE '
                      web_address  = 'http://www.travel-from-walldorf' )
                    ( name         = 'Voyager Enterprises'
                      city         = 'Stockholm                '
                      country_code = 'SE '
                      web_address  = 'http://www.starfleet.ufp' )
                    ( name         = 'Ben McCloskey Ltd.'
                      city         = 'Birmingham'
                      country_code = 'GB'
                      web_address  = 'http://www.ben-mcCloskey.co.uk' )
                    ( name         = 'Pillepalle Trips'
                      city         = 'Zuerich                   '
                      country_code = 'CH '
                      web_address  = 'http://www.pi-pa-tri.sap' )
                    ( name         = 'Kangeroos'
                      city         = 'London                   '
                      country_code = 'GB '
                      web_address  = 'http://www.hopp.sap                          ' )
                    ( name         = 'Bavarian Castle'
                      city         = 'Dresden                  '
                      country_code = 'DE '
                      web_address  = 'http://www.neu.schwanstein.sap               ' )
                    ( name         = 'Ali''s Bazar'
                      city         = 'Boston                   '
                      country_code = 'US '
                      web_address  = 'http://www.ali.sap                           ' )
                    ( name         = 'Super Agency'
                      city         = 'Glasgow'
                      country_code = 'GB'
                      web_address  = 'http://www.super.sap' )
                    ( name         = 'Wang Chong'
                      city         = 'Moscow                   '
                      country_code = 'RU '
                      web_address  = 'http://www.wang.chong.sap' )
                    ( name         = 'Around the World'
                      city         = 'Hannover                 '
                      country_code = 'DE '
                      web_address  = 'http://www.atw.sap' )
                    ( name         = 'No Return'
                      city         = 'Koeln                     '
                      country_code = 'DE '
                      web_address  = 'http://www.bye-bye.sap                       ' )
                    ( name         = 'Special Agency Peru'
                      city         = 'Stuttgart                '
                      country_code = 'DE '
                      web_address  = 'http://www.sap.com                           ' )
                    ( name         = 'Caribian Dreams'
                      city         = 'Emden                    '
                      country_code = 'DE '
                      web_address  = 'http://www.cuba-libre.sap                   ' )
                    ( name         = 'Asia By Plane'
                      city         = 'Tokyo                  '
                      country_code = 'JP'
                      web_address  = 'http://www.asia-by-plane.co.jp' )
                    ( name         = 'Everywhere'
                      city         = 'Muenchen                  '
                      country_code = 'DE '
                      web_address  = 'http://www.everywhere.sap' )
                    ( name         = 'Happy Holiday'
                      city         = 'Bremen                   '
                      country_code = 'DE '
                      web_address  = 'http://www.haphol.sap' )
                    ( name         = 'No Name'
                      city         = 'Aachen                   '
                      country_code = 'DE '
                      web_address  = 'http://www.nn.sap' )
                    ( name         = 'Fly Low'
                      city         = 'Dresden                  '
                      country_code = 'DE '
                      web_address  = 'http://www.fly-low.sap' )
                    ( name         = 'Aussie Travel'
                      city         = 'Manchester               '
                      country_code = 'GB '
                      web_address  = 'http://www.down-under.sap' )
                    ( name         = 'Up ''n'' Away'
                      city         = 'Hannover                 '
                      country_code = 'DE '
                      web_address  = 'http://www.una.sap                           ' )
                    ( name         = 'Trans World Travel'
                      city         = 'Chicago                  '
                      country_code = 'US '
                      web_address  = 'http://www.twt.sap                           ' )
                    ( name         = 'Bright Side of Life'
                      city         = 'San Francisco            '
                      country_code = 'US '
                      web_address  = 'http://www.ruebennase.sap                    ' )
                    ( name         = 'Sunny, Sunny, Sunny'
                      city         = 'Philadelphia             '
                      country_code = 'US '
                      web_address  = 'http://www.s3.sap                           ' )
                    ( name         = 'Fly & Smile'
                      city         = 'Frankfurt                '
                      country_code = 'DE '
                      web_address  = 'http://www.fly-and-smile.sap            ' )
                    ( name         = 'Supercheap'
                      city         = 'Los Angeles              '
                      country_code = 'US '
                      web_address  = 'http://www.supercheap.sap                    ' )
                    ( name         = 'Hitchhiker'
                      city         = 'Issy-les-Moulineaux      '
                      country_code = 'FR '
                      web_address  = 'http://www.42.sap                            ' )
                    ( name         = 'Fly Now, Pay Later'
                      city         = 'New York                 '
                      country_code = 'US '
                      web_address  = 'http://www.fn-pl.sap                         ' )
                    ( name         = 'Real Weird Vacation'
                      city         = 'Vancouver'
                      country_code = 'CA '
                      web_address  = 'http://www.reweva.sap                        ' )
                    ( name         = 'Cap Travels Ltd.'
                      city         = 'Johannesburg'
                      country_code = 'ZA'
                      web_address  = 'http://www.cap-travels.co.za' )
                    ( name         = 'Rainy, Stormy, Cloudy'
                      city         = 'Stuttgart                '
                      country_code = 'DE '
                      web_address  = 'http://www.windy.sap/rsc/                    ' )
                    ( name         = 'Women only'
                      city         = 'Mainz                    '
                      country_code = 'DE '
                      web_address  = 'http://www.women-only.sap                    ' )
                    ( name         = 'Maxitrip'
                      city         = 'Wiesbaden'
                      country_code = 'DE'
                      web_address  = 'http://www.maxitrip.sap' )
                    ( name         = 'The Ultimate Answer'
                      city         = 'Avon                     '
                      country_code = 'GB '
                      web_address  = 'http://www.thulan.sap                        ' )
                    ( name         = 'Intertravel'
                      city         = 'Chicago                  '
                      country_code = 'US '
                      web_address  = 'http://www.intertravel.sap                   ' )
                    ( name         = 'Ultimate Goal'
                      city         = 'Atlanta                  '
                      country_code = 'US '
                      web_address  = 'http://www.ultimate-goal.sap                 ' )
                    ( name         = 'SAP'
                      city         = 'Palo Alto                '
                      country_code = 'US '
                      web_address  = 'http://www.sar.sap                           ' )
                    ( name         = 'Hendrik''s'
                      city         = 'Chicago                  '
                      country_code = 'US '
                      web_address  = 'http://www.essen.sap/150596                  ' )
                    ( name         = 'All British Air Planes'
                      city         = 'Vineland                 '
                      country_code = 'US '
                      web_address  = 'http://www.abap.sap                           ' )
                    ( name         = 'Rocky Horror Tours'
                      city         = 'Santa Monica             '
                      country_code = 'US '
                      web_address  = 'http://www.frank.furter.sap                  ' )
                    ( name         = 'Flights and More'
                      city         = 'Los Walldos'
                      country_code = 'US '
                      web_address  = 'http://www.fam.sap' )
                    ( name         = 'Not Only By Bike'
                      city         = 'Frankfurt                '
                      country_code = 'DE '
                      web_address  = 'http://www.nobb.sap' ) ).
  ENDMETHOD.

  METHOD build_uuid.
    DATA agency_uuid TYPE sysuuid_x16.
    DATA error       TYPE REF TO cx_uuid_error.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<agency>).
      TRY.
          agency_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO error.
          " Should not happen.  If so, something is wrong
          RAISE SHORTDUMP error.
      ENDTRY.

      <agency>-agency_uuid = agency_uuid.
    ENDLOOP.
  ENDMETHOD.

  METHOD build_semantic_key.
    DATA data_lines      TYPE i.
    DATA numberrange_key TYPE cl_numberrange_runtime=>nr_number.
    DATA error           TYPE REF TO cx_number_ranges.
    DATA maximum         TYPE i.
    DATA current         TYPE i.

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

    LOOP AT data ASSIGNING FIELD-SYMBOL(<agency>).
      current += 1.
      <agency>-agency_id = CONV #( current ).
    ENDLOOP.
  ENDMETHOD.

  METHOD insert_content.
    INSERT /dmo/a_agncy_xbo FROM TABLE @data.
  ENDMETHOD.

  METHOD build_admin_fields.
    DATA: admin_field_generator TYPE REF TO /dmo/if_admin_field_generator.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<agency>).
      admin_field_generator = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_adm_field_gen_instance( ).

      <agency>-local_created_at      = admin_field_generator->generate_local_created_at( ).
      <agency>-last_changed_at       = admin_field_generator->generate_last_changed_at( ).
      <agency>-local_last_changed_at = admin_field_generator->generate_local_last_changed_at( ).
      <agency>-local_created_by      = admin_field_generator->generate_local_created_by( ).
      <agency>-local_last_changed_by = admin_field_generator->generate_local_last_changed_by( ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_travel_data_generator DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES /dmo/if_data_generator.

    TYPES currency_code_type TYPE STANDARD TABLE OF I_CurrencyStdVH WITH KEY Currency.
    TYPES country_type       TYPE STANDARD TABLE OF I_CountryText WITH KEY Country.
    TYPES travel_type        TYPE STANDARD TABLE OF /dmo/a_trvl_xbo WITH KEY travel_uuid.

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
    CLASS-DATA agencies               TYPE lcl_agency_data_generator=>agency_type.
    CLASS-DATA currency_codes         TYPE currency_code_type.
    CLASS-DATA countrynames           TYPE country_type.
    CLASS-DATA data                   TYPE travel_type.

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
      RETURNING VALUE(result) TYPE /dmo/a_trvl_xbo-description.

    CLASS-METHODS build_currency_code
      RETURNING VALUE(result) TYPE currency_code_type.

    CLASS-METHODS build_country
      RETURNING VALUE(result) TYPE country_type.

    CLASS-METHODS delete_content.

    CLASS-METHODS insert_content.

ENDCLASS.

CLASS lcl_travel_data_generator IMPLEMENTATION.
  METHOD /dmo/if_data_generator~create.

    DATA(text_output) = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_text_output_instance( out ).
    ##NO_TEXT
    text_output->print_title( 'Travel XBO' ).

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

    DELETE FROM /dmo/d_trvl_xbo. "#EC CI_NOWHERE
    DELETE FROM /dmo/a_trvl_xbo. "#EC CI_NOWHERE

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

    agencies = lcl_agency_data_generator=>get_data( ).
    ran_agency = cl_abap_random_int=>create( seed = seed
                                                min  = start_at_1
                                                max  = lines( agencies ) ).

    currency_codes = build_currency_code( ).
    ran_currency_code = cl_abap_random_int=>create( min = start_at_1
                                                       max = lines( currency_codes ) ).

    countrynames = build_country( ).
    ran_countryname = cl_abap_random_int=>create( min = start_at_1
                                                     max = lines( countrynames ) ).

    ran_travel_description = cl_abap_random_int=>create( min = start_at_1
                                                            max = description_max ).

    ran_total_price_float = cl_abap_random_decfloat16=>create( seed = seed ).
    ran_total_price_int = cl_abap_random_int=>create( min = price_int_min
                                                         max = price_int_max ).
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

      APPEND VALUE /dmo/a_trvl_xbo( travel_uuid = travel_uuid ) TO data.
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
    DATA(country) = countrynames[ ran_countryname->get_next( ) ]-CountryName. "#EC CI_NOORDER

    result = SWITCH /dmo/a_trvl_xbo-description(
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

      <travel>-agency_uuid   = agencies[ ran_agency->get_next( ) ]-agency_uuid.
      <travel>-total_price   = ran_total_price_float->get_next( ) + ran_total_price_int->get_next( ).
      <travel>-currency_code = currency_codes[ ran_currency_code->get_next( ) ]-Currency. "#EC CI_NOORDER
      <travel>-begin_date    = date_generator->generate_date( ).
      <travel>-end_date      = date_generator->generate_new_date_with_offset( <travel>-begin_date ).
      <travel>-description   = generate_description( ).
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

  METHOD build_country.
    SELECT FROM I_CountryText FIELDS country, countryname WHERE language = 'E' INTO TABLE @result.
  ENDMETHOD.

  METHOD insert_content.
    INSERT /dmo/a_trvl_xbo FROM TABLE @data.
  ENDMETHOD.

ENDCLASS.
