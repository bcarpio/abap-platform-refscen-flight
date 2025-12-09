@AccessControl.authorizationCheck: #MANDATORY

@EndUserText.label: 'Agency View for Draft Scope RefScen'

@Metadata.ignorePropagatedAnnotations: true

define root view entity /DMO/R_AGENCYTP_XBO
  as select from /dmo/a_agncy_xbo

  association to many /DMO/R_TRAVELTP_XBO as _Travel on $projection.AgencyUuid = _Travel.AgencyUuid
{
  key agency_uuid           as AgencyUuid,
      agency_id             as AgencyId,
      name                  as Name,
      city                  as City,
      country_code          as CountryCode,
      web_address           as WebAddress,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,

      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      /* Associations */
      _Travel
}
