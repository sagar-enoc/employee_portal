# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1 Employees' do
  before { allow(Rails.configuration.env_vars).to receive(:api_secret).and_return('secret') }

  after { expect(response.media_type).to eq 'application/json' }

  describe 'GET /v1/employees' do
    let(:employee0) { create :employee }
    let(:employee1) { create :employee }
    let(:employee2) { create :employee }
    let(:request_params) { {} }
    let(:request) { get v1_employees_path, headers: request_header, params: request_params }

    before do
      Timecop.freeze(3.days.ago) { employee0.reload }
      Timecop.freeze(2.days.ago) { employee1.reload }
      Timecop.freeze(1.day.ago) { employee2.reload }
      request
    end

    context 'when authentication token invalid' do
      let(:request_header) { { 'X-API-Secret': 'invalid' } }

      it { expect(json_errors).to eq 'Invalid Secret Token.' }
    end

    context 'when authentication token valid' do
      let(:request_header) { { 'X-API-Secret': 'secret' } }

      context 'pagination by page/per_page (deferred joins)' do
        context 'when pagination params not available' do
          let(:expected_response_format) do
            {
              id: employee2.id,
              emp_id: employee2.emp_id,
              email: employee2.email,
              full_name: employee2.full_name,
              address: employee2.address,
              phone_number: employee2.phone_number,
              created_at: employee2.created_at
            }.as_json.deep_symbolize_keys
          end

          it { expect(json_data[0]).to eq expected_response_format }

          it 'fetch ordered the employees by #created_at desc' do
            expect(json_data[0][:id]).to eq employee2.id
            expect(json_data[2][:id]).to eq employee0.id
          end
        end

        context 'when pagination params available' do
          context 'when requested page is available' do
            let(:request_params) { { per_page: 1, page: 3 } }
            let(:pagination) do
              {
                per_page: 1,
                current_page: 3,
                total_count: 3,
                total_pages: 3
              }
            end

            it 'fetch the records for requested page' do
              expect(json_data[0][:id]).to eq employee0.id
            end

            it { expect(json_pagination).to eq(pagination) }
          end

          context 'when requested page is not available' do
            let(:request_params) { { per_page: 1, page: 4 } }

            it { expect(json_data).to be_empty }
          end
        end
      end

      context 'pagination by cursor' do
        context 'when invalid params' do
          context 'when cursor_key is missing' do
            let(:request_params) { { before_cursor: employee1.emp_id } }

            it { expect(json_errors).to eq 'cursor_key is missing.' }
          end

          context 'when cursor_key is not allowed' do
            let(:request_params) { { before_cursor: employee1.emp_id, cursor_key: :email } }

            it { expect(json_errors).to eq 'cursor_key is not allowed for paginating records.' }
          end
        end

        context 'when valid params' do
          let(:request_params) { { after_cursor: employee1.emp_id, cursor_key: :emp_id } }

          it { expect(json_data.size).to eq 1 }
          it { expect(json_data[0][:id]).to eq employee0.id }
        end

        context 'when valid params' do
          let(:request_params) { { before_cursor: employee2.emp_id, cursor_key: :emp_id } }

          it { expect(json_data).to be_empty }
        end

        context 'when valid params' do
          let(:request_params) { { before_cursor: employee0.emp_id, cursor_key: :emp_id } }
          let(:pagination) do
            {
              per_page: 100,
              after_cursor: employee1.emp_id,
              before_cursor: employee2.emp_id
            }
          end

          it { expect(json_data.size).to eq 2 }
          it { expect(json_data[0][:id]).to eq employee2.id }
          it { expect(json_pagination).to eq(pagination) }
        end
      end
    end
  end
end
