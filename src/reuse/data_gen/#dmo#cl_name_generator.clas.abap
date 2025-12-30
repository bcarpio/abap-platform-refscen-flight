CLASS /dmo/cl_name_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES /dmo/if_name_generator.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA name_generator_instance TYPE REF TO /dmo/cl_name_generator.

    DATA first_names TYPE /dmo/if_name_generator~first_names_type.
    DATA last_names  TYPE /dmo/if_name_generator~last_names_type.
    DATA mo_random   TYPE REF TO cl_abap_random_float.

    METHODS build_first_names.
    METHODS build_last_names.
    METHODS init.
ENDCLASS.



CLASS /dmo/cl_name_generator IMPLEMENTATION.

  METHOD /dmo/if_name_generator~get_instance.
    IF name_generator_instance IS NOT BOUND.
      name_generator_instance = NEW /dmo/cl_name_generator( ).
      name_generator_instance->init( ).
    ENDIF.
    instance = name_generator_instance.
  ENDMETHOD.

  METHOD /dmo/if_name_generator~generate.
    result = VALUE /dmo/if_name_generator~name_type(
        first = first_names[ floor( mo_random->get_next( ) * lines( first_names ) ) + 1 ]
        last  = last_names[  floor( mo_random->get_next( ) * lines( last_names  ) ) + 1 ]
      ).
  ENDMETHOD.


  METHOD build_first_names.
    first_names = VALUE /dmo/if_name_generator~first_names_type( ##NO_TEXT
                ( first_name = 'Simon'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Harish'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Volker'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Jasmin'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Felix'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Kristina'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Thilo'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Andrej'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Anna'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Johannes' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Johann'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Christoph' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Andreas' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Stephen' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Mathilde' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'August'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Illya'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Georg'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Gisela'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Christa' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Holm'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Irmtraut' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Ludwig'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Laura'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Kurt'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Guenther' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Horst'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Matthias' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Amelie'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Walter'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Sophie'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Claire'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Chantal' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Jean'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Cindy'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Pierre'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Irene'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Adam'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Fabio'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Lothar'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Annemarie' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Ida'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Roland'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Achim'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Allen'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Lee'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Guillermo' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Florian' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Ulla'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Juan'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Marta'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Salvador' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Christine' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Dominik' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Astrid'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Ruth'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Theresia' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Thomas'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Friedrich' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Anneliese' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Peter'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Anne-Marie' gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'James'  gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Jean-Luc' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Benjamin' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Hendrik' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Uli'  gender = 'F' salutation = 'Mrs.' )
                ( first_name = 'Siegfried' gender = 'M' salutation = 'Mr.' )
                ( first_name = 'Max' gender = 'M' salutation = 'Mr.' )
              ).

  ENDMETHOD.

  METHOD build_last_names.
    last_names = VALUE /dmo/if_name_generator~last_names_type( ##NO_TEXT ##STRING_OK
          ( last_name = 'Buchholm' )
          ( last_name = 'Vrsic' )
          ( last_name = 'Jeremias' )
          ( last_name = 'Gutenberg' )
          ( last_name = 'Fischmann' )
          ( last_name = 'Columbo' )
          ( last_name = 'Neubasler' )
          ( last_name = 'Martin' )
          ( last_name = 'Detemple' )
          ( last_name = 'Barth' )
          ( last_name = 'Benz' )
          ( last_name = 'Hansmann' )
          ( last_name = 'Koslowski' )
          ( last_name = 'Wohl' )
          ( last_name = 'Koller' )
          ( last_name = 'Hoffen' )
          ( last_name = 'Dumbach' )
          ( last_name = 'Goelke' )
          ( last_name = 'Waldmann' )
          ( last_name = 'Mechler' )
          ( last_name = 'Buehler' )
          ( last_name = 'Heller' )
          ( last_name = 'Simonen' )
          ( last_name = 'Henry' )
          ( last_name = 'Marshall' )
          ( last_name = 'Legrand' )
          ( last_name = 'Jacqmain' )
          ( last_name = 'D´Oultrement' )
          ( last_name = 'Hunter' )
          ( last_name = 'Delon' )
          ( last_name = 'Kreiss' )
          ( last_name = 'Trensch' )
          ( last_name = 'Cesari' )
          ( last_name = 'Matthaeus' )
          ( last_name = 'Babilon' )
          ( last_name = 'Zimmermann' )
          ( last_name = 'Kramer' )
          ( last_name = 'Illner' )
          ( last_name = 'Pratt' )
          ( last_name = 'Gahl' )
          ( last_name = 'Benjamin' )
          ( last_name = 'Miguel' )
          ( last_name = 'Weiss' )
          ( last_name = 'Sessler' )
          ( last_name = 'Montero' )
          ( last_name = 'Domenech' )
          ( last_name = 'Moyano' )
          ( last_name = 'Sommer' )
          ( last_name = 'Schneider' )
          ( last_name = 'Eichbaum' )
          ( last_name = 'Gueldenpfennig' )
          ( last_name = 'Sudhoff' )
          ( last_name = 'Lautenbach' )
          ( last_name = 'Ryan' )
          ( last_name = 'Prinz' )
          ( last_name = 'Deichgraeber' )
          ( last_name = 'Pan' )
          ( last_name = 'Lindwurm' )
          ( last_name = 'Kirk' )
          ( last_name = 'Picard' )
          ( last_name = 'Sisko' )
          ( last_name = 'Madeira' )
          ( last_name = 'Meier' )
          ( last_name = 'Rahn' )
          ( last_name = 'Leisert' )
          ( last_name = 'Müller' )
          ( last_name = 'Mustermann' )
          ( last_name = 'Becker' )
          ( last_name = 'Fischer' )
      ).
  ENDMETHOD.


  METHOD init.
    build_first_names( ).
    build_last_names( ).
    mo_random = cl_abap_random_float=>create( ).
  ENDMETHOD.

  METHOD /dmo/if_name_generator~get_first_names.
    result = first_names.
  ENDMETHOD.

  METHOD /dmo/if_name_generator~get_last_names.
    result = last_names.
  ENDMETHOD.

ENDCLASS.
