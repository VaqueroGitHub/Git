public with sharing class Calculator_CTRL {

    /**
    * @description Method to get the AITACodes__c of all the Airport__c in database
    * @param   no param
    * @return List<Airport__c> with the id and the AITACodes__c
    **/

    @AuraEnabled(cacheable=true)
    public static List<Airport__c> getAirports(){
        List<Airport__c> IATACodes = new List<Airport__c>([SELECT id, IATA_Code__c from Airport__c]);
        return IATACodes;
    }


   /**
    * @description Method to calculate the distance between the airports and create and insert the flight in the database
    * @param   IATACodes of the Airports
    * @return List<Airport__c> with the id and the AITACodes__c
    **/     @AuraEnabled
    public static calculateDistanceResponse calculateDistance(String IATA1, String IATA2){
        calculateDistanceResponse res = new calculateDistanceResponse();
        res.errors = new List<String>();
        try {
            // Gets the Airport´s Info
            Airport__c departure = [SELECT id, Latitude__c,Longitude__c FROM  Airport__c WHERE IATA_Code__c=:IATA1 LIMIT 1];
            Airport__c arrival = [SELECT id, Latitude__c,Longitude__c FROM Airport__c WHERE IATA_Code__c=:IATA2 LIMIT 1];
            //Calculates the distance between them and converts it to int and KM
             res.distance= calculateDistance(departure.Latitude__c,departure.Longitude__c,arrival.Latitude__c,arrival.Longitude__c).intValue();          

            // Creates the flight and inserts it
            Flight__C flight = new Flight__C(Name = IATA1+ ' To '+IATA2, Arrival_Airport__c =arrival.Id, Departure_Airport__c= departure.Id, Distance__c = res.distance );
            insert flight;
            res.success='OK';
        }catch (Exception e) {
            res.success = 'KO';
            res.errors.add(e.getMessage());
        }
        return res;
       
    }
    // METHOD PROVIDED BY NUVOLAR
    private static Decimal calculateDistance(Decimal latitude1, Decimal longitude1,
        Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; // in meters
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
        Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
        Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in metres
        distance=distance/1000; // in kilometers
        return distance;
    }
    public class calculateDistanceResponse {
        @AuraEnabled public Integer distance;
        @AuraEnabled public String success;
        @AuraEnabled public List<String> errors;
    }
}