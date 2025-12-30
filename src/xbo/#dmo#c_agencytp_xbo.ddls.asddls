@AccessControl.authorizationCheck: #MANDATORY

@EndUserText.label: 'Agency Proj. View Draft Scope RefScen'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.semanticKey: [ 'AgencyId' ]

@Search.searchable: true

define root view entity /DMO/C_AGENCYTP_XBO
  provider contract transactional_query
  as projection on /DMO/R_AGENCYTP_XBO
{
  key AgencyUuid,
  
      @Search.defaultSearchElement: true 
      AgencyId,
      
      Name,
      
      City,
      CountryCode,
      
      WebAddress,
      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      
      /* Associations */
      _Travel: redirected to /DMO/C_TRAVELTP_XBO_DRAFTDP
}
