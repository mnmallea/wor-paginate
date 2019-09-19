module Wor
  module Paginate
    module Adapters
      class Base
        attr_reader :page

        def initialize(content, page, limit)
          @content = content
          @page = page.to_i
          @limit = limit.to_i
          raise Wor::Paginate::Exceptions::InvalidPageNumber if @page <= 0
          raise Wor::Paginate::Exceptions::InvalidLimitNumber if @limit <= 0
        end

        %i[paginated_content count total_count next_page].each do |method|
          define_method(method) { raise NotImplementedError }
        end

        delegate :total_pages, to: :paginated_content

        def next_page
          return nil if page >= total_pages
          page + 1
        end

        class << self
          def adapt?(content)
            required_methods.all? { |method| content.respond_to? method }
          end

          def required_methods=(methods)
            instance_variable_set(:@required_methods, methods)
          end

          def required_methods
            instance_variable_get(:@required_methods) || []
          end
        end
      end
    end
  end
end
