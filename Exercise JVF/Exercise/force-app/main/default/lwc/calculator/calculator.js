import { LightningElement, track } from 'lwc';
import getAirports from '@salesforce/apex/Calculator_CTRL.getAirports';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import calculateDistance from '@salesforce/apex/Calculator_CTRL.calculateDistance';



export default class Calculator extends LightningElement {

    @track displayList= true;
    @track arrival='';
	@track departure=''; 
    @track airportsList = [];
    @track distance;

    connectedCallback() {
        this.getAirportsJs();
        console.log(this.displayList);
        console.log(this.airportsList.data);
        console.log(this.arrival);
        console.log(this.departure);
    }
    // manage the change of arrival combobox
    handleChange(event) {
        // Get the string of the "value" attribute on the selected option
        const selectedOption = event.detail.value;
        this.arrival = selectedOption;
        this.changeHandler();
    }
        // manage the change of departure combobox
    handleChange1(event) {
        // Get the string of the "value" attribute on the selected option
        const selectedOption = event.detail.value;
        this.departure = selectedOption;
        this.changeHandler();

    }
    // once both conmboboxes are filled this method calls calculateDistance 
    changeHandler(){
        if(this.arrival!=''&& this.departure!=''){
            calculateDistance({
                IATA1:this.arrival,
                IATA2: this.departure,
            }).then(result => {
                this.displayList= false;
				console.log('result '+ result);
				if(result.success == 'OK'){
                    this.distance=result.distance;
					this.closeCalculator();
				}else if (result.success == 'KO'){
					if(Array.isArray(result.errors)){
						for (let i = 0; i < result.errors.length; i++) {
							this.showToast('error', 'ERROR', result.errors[i]);
						}
					}
				}
			})
			.catch(error => {
				console.log(error);
			});
        }

    }

    //Gets airport IATA codes
    getAirportsJs() {
        getAirports({})
        .then(res => {
            if (res) {
                this.airportsList = res.map( el => { return { label : el.IATA_Code__c, value : el.IATA_Code__c } })
            }
        })
    }
    //Displays an message on screen if there is an error
    showToast(type, title, msg) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: type,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    
}