Apex Class:
public with sharing class StudentController {
    @AuraEnabled
    public static Student__c updateStudent(Student__c student){
        // Validate student record
        List<String> errors = new List<String>();
        if (String.isBlank(student.Name__c)) {
            errors.add('Name field is required');
        }
        if (String.isBlank(student.Student_ID__c)) {
            errors.add('Student ID field is required');
        }
        if (String.isBlank(student.Grade__c)) {
            errors.add('Grade field is required');
        }

        // Check for any validation errors
        if (!errors.isEmpty()) {
            throw new AuraHandledException(String.join(errors, '\n'));
        }

        // Save the student record
        upsert student;

        // Return the updated student record
        return student;
    }
}

Lightning Web Component:
<template>
    <lightning-record-edit-form 
        object-api-name="Student__c"
        onsuccess={handleSuccess}
        record-id={recordId}
    >
        <lightning-messages></lightning-messages>
        <lightning-input-field field-name="Name__c"></lightning-input-field>
        <lightning-input-field field-name="Student_ID__c"></lightning-input-field>
        <lightning-input-field field-name="Grade__c"></lightning-input-field>
        <lightning-button type="submit" label="Submit"></lightning-button>
    </lightning-record-edit-form>
</template>

import { LightningElement, api, track, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import STUDENT_OBJECT from '@salesforce/schema/Student__c';
import STUDENT_FIELD from '@salesforce/schema/Student__c.Name__c';

import updateStudent from '@salesforce/apex/StudentController.updateStudent';

export default class StudentForm extends LightningElement {
    @api recordId;
    @track error;

    // Handles form submission
    handleSuccess(event) {
        const fields = event.detail.fields;

        // Create student record
        const recordInput = { apiName: STUDENT_OBJECT.objectApiName, fields };

        // Call Apex class to handle update
        updateStudent({ student: recordInput })
            .then(student => {
                // Show success message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Student record has been updated',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.error = error;
            });
    }
}