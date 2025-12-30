@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: 'Draft Query View Table /DMO/D_TRVL_XBO'
define root view entity /DMO/R_TravelDraft_XBO
  as select from /dmo/d_trvl_xbo
{
  key traveluuid as TravelUuid,
  travelid as TravelId,
  agencyuuid as AgencyUuid,
  begindate as BeginDate,
  enddate as EndDate,
  totalprice as TotalPrice,
  currencycode as CurrencyCode,
  description as Description,
  localcreatedby as LocalCreatedBy,
  localcreatedat as LocalCreatedAt,
  locallastchangedby as LocalLastChangedBy,
  locallastchangedat as LocalLastChangedAt,
  lastchangedat as LastChangedAt,
  draftentitycreationdatetime as draftentitycreationdatetime,
  draftentitylastchangedatetime as draftentitylastchangedatetime,
  draftadministrativedatauuid as draftadministrativedatauuid,
  draftentityoperationcode as draftentityoperationcode,
  hasactiveentity as hasactiveentity,
  draftfieldchanges as draftfieldchanges
}
