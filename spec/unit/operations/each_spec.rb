# frozen_string_literal: true

RSpec.describe Dry::Logic::Operations::Each do
  subject(:operation) { described_class.new(is_string) }

  include_context "predicates"

  let(:is_string) { Dry::Logic::Rule::Predicate.build(str?) }

  describe "#call" do
    it "applies its rules to all elements in the input" do
      expect(operation.(["Address"])).to be_success

      expect(operation.([nil, "Address"])).to be_failure
      expect(operation.([:Address, "Address"])).to be_failure
    end
  end

  describe "#to_ast" do
    it "returns ast" do
      expect(operation.to_ast).to eql([:each, [:predicate, [:str?, [[:input, undefined]]]]])
    end

    it "returns result ast" do
      expect(operation.([nil, 12, nil]).to_ast).to eql(
        [:set, [
          [:key, [0, [:predicate, [:str?, [[:input, nil]]]]]],
          [:key, [1, [:predicate, [:str?, [[:input, 12]]]]]],
          [:key, [2, [:predicate, [:str?, [[:input, nil]]]]]]
        ]]
      )
    end

    it "returns failure result ast" do
      expect(operation.with(id: :tags).([nil, "red", 12]).to_ast).to eql(
        [:failure, [:tags, [:set, [
          [:key, [0, [:predicate, [:str?, [[:input, nil]]]]]],
          [:key, [2, [:predicate, [:str?, [[:input, 12]]]]]]
        ]]]]
      )
    end
  end

  describe "#to_s" do
    it "returns string representation" do
      expect(operation.to_s).to eql("each(str?)")
    end
  end
end
