public with sharing class B2BGetInfo {

    @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductDetail getProduct(
      String communityId,
      String productId,
      String effectiveAccountId
    ) {

      // Lookup the webstore ID associated with the community
        String webstoreId = resolveCommunityIdToWebstoreId(communityId);

        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCatalog_static_methods.htm#apex_ConnectAPI_CommerceCatalog_static_methods
        return ConnectApi.CommerceCatalog.getProduct(
          webstoreId,
          productId,
          effectiveAccountID,
          null,
          false,
          null,
          false,
          true,
          false
        );

    }

    @AuraEnabled(cacheable=true)
    public static Boolean checkProductIsInStock(String productId) {

      // This could be an external call that returns more information, but for simplicity let's make it a random Boolean.
      return Math.random() > 0.5;
    }

    @AuraEnabled()
    public static ConnectApi.CartItem addToCart(
      String communityId,
      String productId,
      String quantity,
      String effectiveAccountId
    ) {

      // Lookup the webstore ID associated with the community
      String webstoreId = resolveCommunityIdToWebstoreId(communityId);

      ConnectApi.CartItemInput cartInput = new ConnectApi.CartItemInput();
      cartInput.productId = productId;
      cartInput.quantity = quantity;
      cartInput.type = ConnectApi.CartItemType.PRODUCT;

      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCart_static_methods.htm#apex_ConnectAPI_CommerceCart_static_methods
      return ConnectApi.CommerceCart.addItemToCart(webstoreId, effectiveAccountId, 'active', cartInput);

    }


    @AuraEnabled(cacheable=true)
    public static ConnectApi.ProductPrice getProductPrice(String communityId, String productId, String effectiveAccountId){

      // Lookup the webstore ID associated with the community
      String webstoreId = resolveCommunityIdToWebstoreId(communityId);

      // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceStorePricing_static_methods.htm#apex_ConnectAPI_CommerceStorePricing_static_methods
      return ConnectApi.CommerceStorePricing.getProductPrice(webstoreId, productId, effectiveAccountId);
  }

  private static String resolveCommunityIdToWebstoreId(String communityId) {
    return [SELECT WebStoreId FROM WebStoreNetwork WHERE NetworkId = :communityId LIMIT 1].WebStoreId;
  }
}