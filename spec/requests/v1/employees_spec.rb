# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1 Employees' do
  before { allow(Rails.configuration.env_vars).to receive(:api_secret).and_return('secret') }

  after { expect(response.media_type).to eq 'application/json' }

  describe 'GET /v1/employees' do
    let(:employee_0) { create :employee }
    let(:employee_1) { create :employee }
    let(:request) { get v1_employees_path, headers: request_header }

    before do
      Timecop.freeze(3.days.ago) { employee_0.reload }
      Timecop.freeze(1.day.ago) { employee_1.reload }
      request
    end

    context 'when authentication token invalid' do
      let(:request_header) { { 'X-API-Secret': 'invalid' } }

      it { expect(json_errors).to eq 'Invalid Secret Token.' }
    end

    let(:expected_response_format) do
      {
        id: employee_1.id,
        emp_id: employee_1.emp_id,
        email: employee_1.email,
        full_name: employee_1.full_name,
        address: employee_1.address,
        phone_number: employee_1.phone_number,
        created_at: employee_1.created_at
      }.as_json.deep_symbolize_keys
    end

    context 'when authentication token valid' do
      let(:request_header) { { 'X-API-Secret': 'secret' } }

      it { expect(json_data[0]).to eq expected_response_format }

      it 'has ordered the employees by #created_at desc' do
        expect(json_data[0][:id]).to eq employee_1.id
        expect(json_data[1][:id]).to eq employee_0.id
      end
    end
  end
end
