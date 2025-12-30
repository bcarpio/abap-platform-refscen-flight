@AccessControl.authorizationCheck: #MANDATORY

@EndUserText.label: 'Travel View for Draft Scope RefScen'

@Metadata.ignorePropagatedAnnotations: true

define root view entity /DMO/R_TRAVELTP_XBO
  as select from /dmo/a_trvl_xbo
  
  association to one /DMO/R_AGENCYTP_XBO as _Agency on $projection.AgencyUuid = _Agency.AgencyUuid
{
  key travel_uuid           as TravelUuid,

      travel_id             as TravelId,
      agency_uuid           as AgencyUuid,
      begin_date            as BeginDate,
      end_date              as EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price           as TotalPrice,

      currency_code         as CurrencyCode,
      description           as Description,

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
      _Agency
}
