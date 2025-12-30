@AccessControl.authorizationCheck: #MANDATORY
@EndUserText.label: 'Booking Projection View with CollDraft'

@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity /DMO/C_Booking_CD as select from /dmo/a_book_cd
//  as projection on /DMO/R_Booking_CD
{
key booking_uuid as BookingUuid
}
