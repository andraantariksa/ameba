module Ameba::Rule::Performance
  # This rule is used to identify usage of arg-less `any?` calls.
  #
  # For example, this is considered invalid:
  #
  # ```
  # [1, 2, 3].any?
  # ```
  #
  # And it should be written as this:
  #
  # ```
  # ![1, 2, 3].empty?
  # ```
  #
  # YAML configuration example:
  #
  # ```
  # Performance/AnyInsteadOfEmpty:
  #   Enabled: true
  # ```
  class AnyInsteadOfEmpty < Base
    properties do
      description "Identifies usage of arg-less `any?` calls."
    end

    ANY_NAME = "any?"
    MSG      = "Use `!{...}.empty?` instead of `{...}.any?`"

    def test(source, node : Crystal::Call)
      return unless node.name == ANY_NAME
      return unless node.block.nil? && node.args.empty?
      return unless node.obj

      issue_for node.name_location, node.name_end_location, MSG
    end
  end
end
