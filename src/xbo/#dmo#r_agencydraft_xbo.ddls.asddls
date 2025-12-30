@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: 'Draft Query View Table /DMO/D_AGNCY_XBO'
define root view entity /DMO/R_AgencyDraft_XBO
  as select from /dmo/d_agncy_xbo
{
  key agencyuuid as AgencyUuid,
  agencyid as AgencyId,
  name as Name,
  city as City,
  countrycode as CountryCode,
  webaddress as WebAddress,
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
