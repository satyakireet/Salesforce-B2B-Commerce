import { LightningElement, api, wire, track } from 'lwc';
import getDeliveryDateforOrder from "@salesforce/apex/GetDesiredDeliveryDate.getDeliveryDateforOrder";

export default class OrderDeliveryDate extends LightningElement {
   @track deliverydate;
   @track error;
   @api recordId


    @wire(getDeliveryDateforOrder, {orderId: "$recordId"})
    myOrderSummary;
}