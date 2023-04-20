import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getStudentDetails from '@salesforce/apex/StudentController.getStudentDetails';
import updateStudentDetails from '@salesforce/apex/StudentController.updateStudentDetails';

export default class EditStudent extends LightningElement {
    @api studentId;
    @track studentDetails;
    @track error;

    // Get Student Details from Apex controller
    connectedCallback() {
        this.getStudentDetails();
    }

    // Fetch the Student Details from Apex
    getStudentDetails() {
        getStudentDetails({ studentId: this.studentId })
            .then(result => {
                this.studentDetails = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    // Handle record update
    handleSuccess(event) {
        const updatedRecord = event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Student record has been updated successfully.',
                variant: 'success',
            }),
        );
        // Refresh Student Details
        this.getStudentDetails();
    }

    // Update Student Details
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Id = this.studentId;
        updateStudentDetails({ student: fields })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Student record has been updated successfully.',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.error = error;
            });
    }
}