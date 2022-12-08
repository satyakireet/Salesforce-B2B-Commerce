import { LightningElement, wire, api } from "lwc";

import communityId from '@salesforce/community/Id';
import getProduct from "@salesforce/apex/B2BGetInfo.getProduct";
import checkProductIsInStock from "@salesforce/apex/B2BGetInfo.checkProductIsInStock";
import addToCart from "@salesforce/apex/B2BGetInfo.addToCart";
import getProductPrice from "@salesforce/apex/B2BGetInfo.getProductPrice";
import { resolve } from "c/cmsResourceResolver";

/**
 * A detailed display of a product.
 * This outer component layer handles data retrieval and management, as well as projection for internal display components.
 */
export default class ProductDetails extends LightningElement {

    /**
     * Gets or sers the effective account - if any - of the user viewing the product.
     *
     * @type {string}
     */
    @api
    effectiveAccountId;

    /**
     *  Gets or sets the unique identifier of a product.
     * 
     * @type {string}
     */
    @api
    recordId;

    /**
     * The stock status of the product, i.e. whether it is "in stock."
     *
     * @type {Boolean}
     * @private
     */
    @wire(checkProductIsInStock, {
        productId: "$recordId"
    })
    inStock;

    /**
     * The full product information retrieved.
     *
     * @type {ConnectApi.ProductDetail}
     * @private
     */
    @wire(getProduct, {
        communityId: communityId,
        productId: "$recordId",
        effectiveAccountId: "$resolvedEffectiveAccountId"
    })
    product;

    /**
     * The price of the product for the user, if any.
     *
     * @type {ConnectApi.ProductPrice}
     * @private
     */
    @wire(getProductPrice, {
        communityId: communityId,
        productId: "$recordId",
        effectiveAccountId: "$resolvedEffectiveAccountId"
    })
    productPrice;

    /**
     * Gets the normalized effective account of the user.
     *
     * @type {string}
     * @readonly
     * @private
     */
    get resolvedEffectiveAccountId() {
        //return "001T1000001nGYQIA2";
        const effectiveAcocuntId = this.effectiveAccountId || "";
        let resolved = null;

        if (effectiveAcocuntId.length > 0 && effectiveAcocuntId !== "000000000000000") {
            resolved = effectiveAcocuntId;
        }
        return resolved;
    }

    /**
     * Gets whether product information has been retrieved for display.
     *
     * @type {Boolean}
     * @readonly
     * @private
     */
    get hasProduct() {
        return this.product.data !== undefined;
    }

    /**
     * Gets the normalized, displayable product information for use by the display components.
     *
     * @readonly
     */
    get displayableProduct() {
        return {
            categoryPath: this.product.data.primaryProductCategoryPath.path.map(category => ({
                id: category.id,
                name: category.name
            })),
            description: this.product.data.fields.Description,
            image: {
                alternativeText: this.product.data.defaultImage.alternativeText,
                url: resolve(this.product.data.defaultImage.url)
            },
            inStock: this.inStock.data === true,
            name: this.product.data.fields.Name,
            price: {
                currency: (this.productPrice.data || {}).currencyIsoCode,
                negotiated: (this.productPrice.data || {}).unitPrice
            },
            sku: this.product.data.fields.StockKeepingUnit
        };
    }

    /**
     * Handles a user request to add the product to their active cart.
     * 
     * @private
     */
    addtoCart() {

        addToCart({
            communityId: communityId,
            productId: this.recordId,
            quantity: "1",
            effectiveAccountId: this.resolvedEffectiveAccountId
        })
            .then(result => {
                console.log(result);
                console.log('no errors');
            })
            .catch(error => {
                this.error = error;
                console.log('errors');
            });

    }
}