# frozen_string_literal: true

RSpec.describe Dry::Logic::Operations::Negation do
  subject(:operation) { described_class.new(is_int) }

  include_context "predicates"

  let(:is_int) { Dry::Logic::Rule::Predicate.build(int?) }

  describe "#call" do
    it "negates its rule" do
      expect(operation.("19")).to be_success
      expect(operation.(17)).to be_failure
    end

    context "double negation" do
      subject(:double_negation) { described_class.new(operation) }

      it "works as rule" do
        expect(double_negation.("19")).to be_failure
        expect(double_negation.(17)).to be_success
      end
    end
  end

  describe "#to_ast" do
    it "returns ast" do
      expect(operation.to_ast).to eql(
        [:not, [:predicate, [:int?, [[:input, undefined]]]]]
      )
    end

    it "returns result ast" do
      expect(operation.(17).to_ast).to eql(
        [:not, [:predicate, [:int?, [[:input, 17]]]]]
      )
    end

    it "returns result ast with an :id" do
      expect(operation.with(id: :age).(17).to_ast).to eql(
        [:failure, [:age, [:not, [:predicate, [:int?, [[:input, 17]]]]]]]
      )
    end
  end

  describe "#to_s" do
    it "returns string representation" do
      expect(operation.to_s).to eql("not(int?)")
    end
  end
end
