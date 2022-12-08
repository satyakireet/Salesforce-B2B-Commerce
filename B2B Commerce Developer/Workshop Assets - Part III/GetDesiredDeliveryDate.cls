public with sharing class GetDesiredDeliveryDate {

    @AuraEnabled(cacheable=true)
    public static String getDeliveryDateforCart(
      String cartId
    ) {
      String desireddate = 'dfdf';
      try{
      
       List<CartDeliveryGroup> deliveryGroup = Database.query(
            'SELECT Id, DesiredDeliveryDate FROM CartDeliveryGroup WHERE CartID=\''+cartId+'\'');

        for(CartDeliveryGroup cdg: deliveryGroup){
          Date myDate = cdg.desireddeliverydate.date();
          desireddate = myDate.format();
        }
        
    } catch (ConnectApi.ConnectApiException e) {
        String errorMessage = e.getMessage();
        System.debug('Error Message: ' + e);
      }

      return desireddate;
    }

    @AuraEnabled(cacheable=true)
    public static String getDeliveryDateforOrder(String orderId) {
      String desireddate = '';
      try{
      
       List<OrderDeliveryGroup> deliveryGroup = Database.query(
         'SELECT Id, DesiredDeliveryDate, OrderId FROM OrderDeliveryGroup where OrderId IN (Select OriginalOrderId from OrderSummary where id=\''+orderId+'\')');

        for(OrderDeliveryGroup odg: deliveryGroup){
          System.debug('date' );
          Date myDate = odg.desireddeliverydate;
          desireddate = myDate.format();
          System.debug('date' + desireddate);
        }
        
    } catch (ConnectApi.ConnectApiException e) {
        String errorMessage = e.getMessage();
        System.debug('Error Message: ' + e);
      }

      return desireddate;
    }


  }