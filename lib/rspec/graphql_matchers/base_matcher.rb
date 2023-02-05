module RSpec
  module GraphqlMatchers
    class BaseMatcher
      private

      def member_name(member)
        member.respond_to?(:graphql_name) && member.graphql_name ||
          member.respond_to?(:name) && member.name ||
          member.inspect
      end

      def types_match?(actual_type, expected_type)
        expected_type.nil? || type_name(expected_type) == type_name(actual_type)
      end

      def type_name(a_type)
        a_type = a_type.to_graphql if a_type.respond_to?(:to_graphql)
        a_type = old_name(a_type) if a_type.respond_to?(:of_type)
        a_type = a_type.to_s.split('::').last
        a_type = a_type.gsub('Type', '') if a_type.ends_with?('Type')
        a_type
      end

      def old_name(a_type)
        types = [a_type]
        while types.last.respond_to?(:of_type)
          types << types.last.of_type
        end
        final_type = types[-1].name.split('::').last
        final_type = final_type.gsub('Type', '') if final_type.ends_with?('Type')
        final_type += '!' if types[-2].non_null?
        final_type = "[#{final_type}]" if a_type.list?
        final_type = "!" if a_type.non_null?
        final_type
      end
    end
  end
end
