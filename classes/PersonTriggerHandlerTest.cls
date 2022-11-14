@IsTest
public with sharing class PersonTriggerHandlerTest {
    
    @isTest
    private static void beforeInsert_createPerson_personCreated() {
        Passport__c passport = new Passport__c(Name='Passport Viktor');
        insert passport;
        Person__c person = new Person__c(Name='Viktor', Passport__c=passport.Id);

        Test.startTest();
        Database.SaveResult result = Database.insert(person, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    }

    @isTest
    private static void beforeInsert_errorWhileCreatePersonLinkingPassport_personWasNotCreated() {
        Passport__c passport = new Passport__c(Name='Passport Viktor');
        insert passport;
        Person__c personViktor = new Person__c(Name='Viktor', Passport__c=passport.Id);
        insert personViktor;
        Person__c personAndrey = new Person__c(Name='Andrey', Passport__c=passport.Id);

        Test.startTest();
        Database.SaveResult result = Database.insert(personAndrey, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Passport Viktor is linked to another Person!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePerson_personWasUpdated() {
        Passport__c passport = new Passport__c(Name='Passport Viktor');
        insert passport;
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        personViktor.Passport__c = passport.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(personViktor, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    }

    @isTest
    private static void beforeUpdate_UpdatePersonWithPassportLinkedToOtherPerson_personWasNotUpdated() {
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor');
        insert passportViktor;
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor; 
        Person__c personAndrey = new Person__c(Name='Andrey');
        insert personAndrey; 
        personViktor.Passport__c = passportViktor.Id;
        update personViktor;
        personAndrey.Passport__c = passportViktor.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(personAndrey, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Passport Viktor is linked to another Person!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePersonLinkedtoPassport_personWasNotUpdated() {
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor');
        insert passportViktor;
        Passport__c passportAndrey = new Passport__c(Name='Passport Andrey');
        insert passportAndrey;
        passportViktor.Person__c = personViktor.Id;
        update passportViktor;
        personViktor.Passport__c = passportAndrey.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(personViktor, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Viktor is linked to another Passport!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePersonWithLinkedPassport_personWasNotUpdated() {
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor', Person__c=personViktor.Id);
        insert passportViktor;
        Person__c personAndrey = new Person__c(Name='Andrey');
        insert personAndrey;
        personAndrey.Passport__c = passportViktor.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(personAndrey, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Passport Viktor is linked with another Person!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePersonWithAnotherPassport_persontWasNotUpdated() {
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor');
        insert passportViktor;
        Passport__c passportAndrey = new Passport__c(Name='Passport Andrey');
        insert passportAndrey; 
        Person__c personViktor = new Person__c(Name='Viktor', Passport__c=passportViktor.Id);
        insert personViktor;
        personViktor.Passport__c = passportAndrey.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(personViktor, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('A Passport allready exist for the Person!', result.getErrors()[0].getMessage());
    }
}