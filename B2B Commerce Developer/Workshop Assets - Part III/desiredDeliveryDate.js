import { LightningElement, api, wire, track } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getDeliveryDateforCart from "@salesforce/apex/GetDesiredDeliveryDate.getDeliveryDateforCart";

export default class DesiredDeliveryDate extends LightningElement {
   @track deliverydate;
   
    @api 
    get cartId(){
        return this._cartId;
    }

    set cartId(val){
        this._cartId = val;
    }

    @wire(getDeliveryDateforCart, {cartId: "$cartId"})
    myCart;

    
}