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

        a_type.to_s
      end

      def old_name(a_type)
        of_type = a_type.of_type
        final_type = of_type.name.split('::').last
        final_type += '!' if a_type.non_null?
        final_type = "[#{final_type}]" if a_type.list?
        final_type
      end
    end
  end
end
