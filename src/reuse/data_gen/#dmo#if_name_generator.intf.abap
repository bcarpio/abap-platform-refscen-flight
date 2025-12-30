INTERFACE /dmo/if_name_generator
  PUBLIC.
  TYPES: BEGIN OF first_name_type,
           first_name TYPE c LENGTH 40,
           gender     TYPE c LENGTH 1,
           salutation TYPE c LENGTH 4,
         END OF first_name_type.
  TYPES: BEGIN OF name_type,
           first TYPE first_name_type,
           last  TYPE c LENGTH 40,
         END OF name_type.
  TYPES first_names_type TYPE STANDARD TABLE OF first_name_type WITH DEFAULT KEY.
  TYPES: BEGIN OF last_name_type,
           last_name TYPE c LENGTH 40,
         END OF last_name_type.
  TYPES last_names_type TYPE STANDARD TABLE OF last_name_type WITH DEFAULT KEY.

  CLASS-METHODS get_instance
    RETURNING VALUE(instance) TYPE REF TO /dmo/cl_name_generator.

  METHODS generate
    RETURNING VALUE(result) TYPE name_type.

  METHODS get_first_names
    RETURNING VALUE(result) TYPE first_names_type.

  METHODS get_last_names
    RETURNING VALUE(result) TYPE last_names_type.

ENDINTERFACE.
