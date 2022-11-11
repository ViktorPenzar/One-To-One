trigger PassportValidation on Passport__c (before insert, before update) {

    if (trigger.isBefore && trigger.isInsert) {
        PassportTriggerHandler.beforeInsert(trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        PassportTriggerHandler.beforeUpdate(Trigger.new);
    }
}