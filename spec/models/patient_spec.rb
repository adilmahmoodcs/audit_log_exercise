require 'rails_helper'
    # 1. patient should create
    # 2. patient attributes should update
    # 3. update last name should create activity
    # 4. update last name and activity log message


RSpec.describe Patient, type: :model do

  context 'create' do
    it 'should be create a new patient' do
      create(:patient, first_name: 'mike')
      expect(Patient.count).to eq(1)
    end
  end

  context 'after create' do

    it 'triggers track_on_create on create' do
      patient = Patient.new(first_name: 'blake', last_name: 'parker', physician_name: 'Mark')
      expect(patient).to receive(:track_on_create)
      patient.save
    end

    it 'should create activity log after patient creates' do
      expect(ActivityLog.count).to eq(0)
      patient = create(:patient, first_name: 'blake', last_name: 'parker', physician_name: 'Mark')
      expect(ActivityLog.count).to eq(1)
      expect(ActivityLog.last.model_id).to eq(patient.id)
      expect(ActivityLog.last.model_type).to eq("Patient")
      expect(ActivityLog.last.changes_text).to eq("Patient Created {id: '1', first_name: 'blake', last_name: 'parker', and physician_name: 'Mark'}")
    end
  end

  context 'update' do
    let(:patient) { create(:patient, first_name: 'blake') }


    it 'should be update the first name' do
      patient.first_name = 'json'
      patient.save
      expect(patient.first_name).to eq('json')
    end

    it 'should be update the last name' do
      patient.last_name = 'roy'
      patient.save
      expect(patient.last_name).to eq('roy')
    end

    it 'should be update the physician name' do
      patient.physician_name = 'michael clarke'
      patient.save
      expect(patient.physician_name).to eq('michael clarke')
    end
  end

  context 'after Update' do
    let(:patient) { create(:patient, first_name: 'blake') }

    it 'triggers track_on_update on update' do
      expect(patient).to receive(:track_on_update)
      patient.save
    end

    it 'should create activity log after patient updates' do
      patient
      expect(ActivityLog.count).to eq(1)
      expect{
        patient.update(first_name: 'mark')
      }.to(change(ActivityLog, :count).by(1))
      expect(ActivityLog.count).to eq(2)
      expect(ActivityLog.last.model_id).to eq(patient.id)
      expect(ActivityLog.last.model_type).to eq("Patient")
      expect(ActivityLog.last.changes_text).to eq("Patient Updated {first_name from 'blake' to 'mark'}")
    end
  end

  context 'destroy' do


    it 'should be deleted the record' do
      patient = create(:patient, first_name: 'blake')
      expect(Patient.count).to eq(1)
      expect{
        patient.destroy
      }.to(change(Patient, :count).by(-1))
      expect(Patient.count).to eq(0)
    end
  end

  context 'before destroy' do
    let(:patient) { create(:patient, first_name: 'blake') }

    it 'triggers track_on_destroy on destroy' do
      expect(patient).to receive(:track_on_destroy)
      patient.destroy
    end

    it 'should create activity log after patient deleted' do
      patient
      expect(ActivityLog.count).to eq(1)
      expect{
        patient.destroy
      }.to(change(ActivityLog, :count).by(1))
      expect(ActivityLog.count).to eq(2)
      expect(ActivityLog.last.model_id).to eq(patient.id)
      expect(ActivityLog.last.model_type).to eq("Patient")
      expect(ActivityLog.last.changes_text).to eq("Patient Deleted")
    end
  end

end
