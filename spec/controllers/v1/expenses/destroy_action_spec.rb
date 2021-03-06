require 'rails_helper'

RSpec.describe V1::ExpensesController, '#destroy',
               type: :request do
  let(:body) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:expense) { create(:expense, user: user) }

  let(:headers) { authorization_header(user.id) }

  before { delete v1_expense_path(expense), headers: headers }

  context 'when the user is authenticated' do
    context 'and the expense belongs to the current user' do
      it { expect(response).to have_http_status(:no_content) }
      it { expect(Expense.count).to eq 0 }
    end

    context 'and the expense does not exist' do
      let(:expense) { -1 }

      it { expect(response).to have_http_status(:not_found) }
      it do
        error_message = "Couldn't find Expense with 'id'=-1"
        expect(body).to include('errors' => error_message)
      end
    end
  end

  context 'when the user is not authenticated' do
    let(:headers) { {} }
    it { expect(response).to have_http_status(:unauthorized) }
    it { expect(body).to include('message' => 'Unauthorized') }
  end
end
