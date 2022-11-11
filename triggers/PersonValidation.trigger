trigger PersonValidation on Person__c (before insert, before update) {

    if (trigger.isBefore && trigger.isInsert) {
        PersonTriggerHandler.beforeInsert(trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        PersonTriggerHandler.beforeUpdate(Trigger.new);
    }
}