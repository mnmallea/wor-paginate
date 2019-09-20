require 'spec_helper'

describe Wor::Paginate::Adapters::KaminariAlreadyPaginated do
  describe '#index' do
    let!(:n) { 28 }
    let!(:n_page) { 10 }
    let!(:dummy_models) { create_list(:dummy_model, n) }

    context 'when paginating something already paginated' do
      context 'with no results' do
        let!(:paginated) { DummyModel.paginate(page: 5) }
        let(:adapter) do
          Wor::Paginate::Adapters::WillPaginateAlreadyPaginated.new(paginated, 1, n_page)
        end

        it 'responds to count' do
          expect(adapter.count).to be n_page
        end

        it 'responds to required_methods' do
          expect(adapter.required_methods).not_to be_empty
        end

        it 'responds to paginated_content' do
          expect(adapter.paginated_content.class).to be paginated.class
        end
      end

      context 'with results' do
        let!(:paginated) { DummyModel.paginate(page: 1) }
        let(:adapter) do
          Wor::Paginate::Adapters::WillPaginateAlreadyPaginated.new(paginated, 1, n_page)
        end

        it 'responds to count' do
          expect(adapter.count).to be n_page
        end

        it 'responds to required_methods' do
          expect(adapter.required_methods).not_to be_empty
        end

        it 'responds to paginated_content' do
          expect(adapter.paginated_content.class).to be paginated.class
        end
      end
    end
  end
end
