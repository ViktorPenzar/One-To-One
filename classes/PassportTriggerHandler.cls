public with sharing class PassportTriggerHandler {

    public static void beforeInsert(List<Passport__c> triggerNew) {
        passportCheck(triggerNew);
    }

    public static void beforeUpdate(List<Passport__c> triggerNew) {
        passportCheck(triggerNew);
    }

    public static void passportCheck(List<Passport__c> triggerNew) {
        Set<Id> personIds = new Set<Id>();
        Set<Id> passportIds = new Set<Id>();
        for (Passport__c p : (List<Passport__c>)trigger.New) {
            personIds.add(p.Person__c); 
            passportIds.add(p.Id);
        }
        List<Person__c> personList = new List<Person__c>([SELECT Id, Name, Passport__c,  (SELECT Id, Name, Person__c FROM Passports__r ) FROM Person__c WHERE Id IN : personIds]);
        List<Person__c> passportLinked = new List<Person__c>([SELECT Id, Name, Passport__c FROM Person__c WHERE Passport__c IN : passportIds]);
        List<Passport__c> personLinked = new List<Passport__c>([SELECT Id, Name, Person__c FROM Passport__c WHERE Person__c IN : personIds]);
        for (Person__c person : personList) {
            for (Passport__c passport : (List<Passport__c>)trigger.new){
                if(!personLinked.isEmpty()) {
                    passport.addError('The '+person.Name+' is linked to another Passport!');
                }
                if(!passportLinked.isEmpty()) {
                    if(person.Passport__c != passport.Id) {
                        passport.addError('The '+passport.Name+' is linked to another Person!');
                    }
                }
                if(person.Passport__c != null) {
                    if(person.Passport__c != passport.Id) {
                        passport.addError('Another Passport is linked to '+person.Name+'!');
                    }
                }
                if(Trigger.oldMap != null) {
                    Passport__c oldPassport = (Passport__c)Trigger.oldMap.get(passport.Id);
                    if(oldPassport.Person__c != null) {
                        if(passport.Person__c != oldPassport.Person__c ) {
                            passport.addError('You can\'t change a person for the passport!');
                        }
                    }
                }
            }
        }
    }
}
