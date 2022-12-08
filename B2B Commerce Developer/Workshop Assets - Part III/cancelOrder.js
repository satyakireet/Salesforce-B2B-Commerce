import { LightningElement, api, wire, track } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class CancelOrder extends LightningElement {

    @api recordId
   
    @api 
    get cartId(){
        return this._cartId;
    }

    set cartId(val){
        this._cartId = val;
    }


}