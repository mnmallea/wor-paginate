module Wor
  module Paginate
    class Formatter
      attr_accessor :adapter, :content, :formatter, :options

      def initialize(adapter, options = {})
        @adapter = adapter
        @options = options
      end

      def format
        {
          page: serialized_content,
          count: count,
          total_pages: total_pages,
          total_count: total_count,
          current_page: current_page,
          next_page: next_page
        }
      end

      protected

      def count
        return [options[:total_count], limit].min if options[:total_count]
        adapter.count
      end

      def total_count
        options[:total_count] || adapter.total_count
      end

      def total_pages
        (total_count.to_f / limit.to_f).ceil
      end

      def limit
        options[:limit]
      end

      def current_page
        adapter.page.to_i
      end

      def next_page
        return nil if current_page >= total_pages
        current_page + 1
      end

      def paginated_content
        @content ||= adapter.paginated_content
      end

      def serialized_content
        if serializer.present?
          return paginated_content.map { |item| serializer.new(item, options) }
        end
        if defined? ActiveModelSerializers::SerializableResource
          ActiveModelSerializers::SerializableResource.new(paginated_content).as_json
        else
          paginated_content.as_json
        end
      end

      def serializer
        options[:each_serializer]
      end
    end
  end
end
