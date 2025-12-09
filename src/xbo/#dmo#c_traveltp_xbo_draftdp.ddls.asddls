@AccessControl.authorizationCheck: #MANDATORY

@EndUserText.label: 'Travel Proj. View Draft Scope RefScen'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.semanticKey: [ 'TravelId' ]

@Search.searchable: true

define root view entity /DMO/C_TRAVELTP_XBO_DRAFTDP
  provider contract transactional_query
  as projection on /DMO/R_TRAVELTP_XBO
{
  key TravelUuid,
 
      @Search.defaultSearchElement: true 
      TravelId,
      
      AgencyUuid,
      
      BeginDate,
      EndDate,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CurrencyStdVH', element: 'Currency' },
                                            useForValidation: true } ]
      CurrencyCode,
      
      Description,
      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      
      /* Associations */
      _Agency: redirected to /DMO/C_AGENCYTP_XBO
}
