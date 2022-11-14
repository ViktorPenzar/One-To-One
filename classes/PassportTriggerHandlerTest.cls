@IsTest
public with sharing class PassportTriggerHandlerTest {

    @isTest
    private static void beforeInsert_createPassport_passportCreated() {
        Person__c person = new Person__c(Name='Viktor');
        insert person;
        Passport__c passport = new Passport__c(Name='Passport Viktor', Person__c=person.Id);

        Test.startTest();
        Database.SaveResult result = Database.insert(passport, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    }

    @isTest
    private static void beforeInsert_errorWhileCreateAdditionalPassport_passportWasNotCreated() {
        Person__c person = new Person__c(Name='Viktor');
        insert person;
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor', Person__c=person.Id);
        insert passportViktor;
        Passport__c passportAndrey = new Passport__c(Name='Passport Andrey', Person__c=person.Id);

        Test.startTest();
        Database.SaveResult result = Database.insert(passportAndrey, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Viktor is linked to another Passport!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePassport_passportWasUpdated() {
        Passport__c passport = new Passport__c(Name='Passport Viktor');
        insert passport;
        Person__c person = new Person__c(Name='Viktor');
        insert person;
        passport.Person__c = person.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(passport, false);
        Test.stopTest();

        System.assert(result.isSuccess());
    }

    @isTest
    private static void beforeUpdate_UpdatePassportWithPersonLinkedToOtherPassport_passportWasNotUpdated() {
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor');
        insert passportViktor; 
        Passport__c passportAndrey = new Passport__c(Name='Passport Andrey');
        insert passportAndrey; 
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        passportViktor.Person__c = personViktor.Id;
        update passportViktor;
        passportAndrey.Person__c = personViktor.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(passportAndrey, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Viktor is linked to another Passport!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePassportLinkedToPersonWhithPerson_passportWasNotUpdated() {
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor');
        insert passportViktor;
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        Person__c personAndrey = new Person__c(Name='Andrey');
        insert personAndrey;
        personViktor.Passport__c = passportViktor.Id;
        update personViktor;
        passportViktor.Person__c = personAndrey.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(passportViktor, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Passport Viktor is linked to another Person!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePassportWithLinkedPersonToOtherPassport_passportWasNotUpdated() {
        Passport__c passportViktor = new Passport__c(Name='Passport Viktor');
        insert passportViktor;
        Passport__c passportAndrey = new Passport__c(Name='Passport Andrey');
        insert passportAndrey;
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        personViktor.Passport__c = passportViktor.Id;
        update personViktor;
        passportAndrey.Person__c = personViktor.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(passportAndrey, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Another Passport is linked to Viktor!', result.getErrors()[0].getMessage());
    }

    @isTest
    private static void beforeUpdate_UpdatePassportWithAnotherPerson_passportWasNotUpdated() {
        Passport__c passport = new Passport__c(Name='Passport Viktor');
        insert passport; 
        Person__c personViktor = new Person__c(Name='Viktor');
        insert personViktor;
        passport.Person__c = personViktor.Id;
        update passport;
        Person__c personAndrey = new Person__c(Name='Andrey');
        insert personAndrey;
        passport.Person__c = personAndrey.Id;

        Test.startTest();
        Database.SaveResult result = Database.update(passport, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('You can\'t change a person for the passport!', result.getErrors()[0].getMessage());
    }
}
