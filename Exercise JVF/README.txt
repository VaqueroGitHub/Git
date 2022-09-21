

Hi and thank you for reading this .txt


First of all i created two new objects Airport (Airport__c) and Flight (Flight__c).

The first one has the following custom fields
- NAME: IATA Code	  API: IATA_Code__c
- NAME: Latitude	  API: Latitude__c
- NAME: Longitude	  API: Longitude__c


And Flight__c

- NAME: Departure Airport	API: Departure_Airport__c
- NAME: Arrival Airport		API: Arrival_Airport__c
- NAME: Distance			API: Distance__c


Then i created some Airport__c records from Barcelona, Madrid and Santander (There is also an excel included at this zip with them to make the testing easier.

On the other hand i decided to create a LWC called calculator and the controller

it just need to be added to the Airport Page or any other one to be functional.

It is composed by 2 comboboxes that export the info about the Airports on the database and once the user selects both airports the distance is calculated and
displayed on the screen as an integer in KM.



All metadata, html, js and apex class are inclueded in this zip


Any doubt please contact me

Javier Vaquero Fernández
Phone: 669649121
Mail: javier_vaquero@yahoo.es