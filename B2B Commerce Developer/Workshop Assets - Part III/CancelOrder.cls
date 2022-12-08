public with sharing class CancelOrder {
    public CancelOrder() {

    }

    @InvocableMethod(label='Cancel Order' description='Cancel the order summary.' category='B2B Commerce')
    public static void cancelOrder(List<String> orderSumaryIds) {

        String id = '';

        try {

            for(String orderSummaryId: orderSumaryIds){
                id = orderSummaryId;
            }
        
            OrderSummary os = Database.query(
              'SELECT Id, Status FROM OrderSummary WHERE id=\''+id+'\' LIMIT 1');
            os.status = 'Cancelled';
            update os;

        } catch (DmlException e) {
            String errorMessage = e.getMessage();
            System.debug('Error Message: ' + e);
        }
    }
}
