public with sharing class PersonTriggerHandler {

    public static void beforeInsert(List<Person__c> triggerNew) {
        passportCheck(triggerNew);
    }

    public static void beforeUpdate(List<Person__c> triggerNew) {
        passportCheck(triggerNew);
    }

    public static void passportCheck(List<Person__c> triggerNew) {
        Set<id> passportIds = new Set<id>();
        Set<Id> personIds = new Set<Id>();
        for (Person__c p : (List<Person__c>)trigger.New) {
            passportIds.add(p.Passport__c);
            personIds.add(p.Id);
        }
        List<Passport__c> passportList = new List<Passport__c>([SELECT Id, Name, Person__c,  (SELECT Id, Passport__c FROM Persons__r) FROM Passport__c WHERE Id IN : passportIds]);
        List<Passport__c> personLinked = new List<Passport__c>([SELECT Id, Name, Person__c FROM Passport__c WHERE Person__c IN : personIds]);
        List<Person__c> passportLinked = new List<Person__c>([SELECT Id, Name, Passport__c FROM Person__c WHERE Passport__c IN : passportIds]);
        for (Passport__c passport : passportList) {
            for (Person__c person : (List<Person__c>)trigger.new){
                if(!passportLinked.isEmpty()) {
                    person.addError('The '+passport.Name+' is linked to another Person!');
                }
                if(!personLinked.isEmpty()) {
                    if(passport.Person__c != person.Id) {
                        person.addError('The '+person.Name+' is linked to another Passport!');
                    }
                }
                if(passport.Person__c != null) {
                    if(passport.Person__c != person.Id) {
                        person.addError('The '+passport.Name+' is linked with another Person!');
                    }
                }
                if(Trigger.oldMap != null){
                    Person__c oldPerson = (Person__c)Trigger.oldMap.get(person.Id);
                    if(oldPerson.Passport__c != null) {
                        if(person.Passport__c != oldPerson.Passport__c ) {
                            person.addError('A Passport allready exist for the Person!');
                        }
                    }
                }
            }
        }
    }
}